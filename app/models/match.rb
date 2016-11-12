class Match < ActiveRecord::Base
  WINNER_SQL = %{ "matches"."victor_id" }.freeze
  LOSER_SQL = <<-SQL.freeze
    CASE
    WHEN "matches"."victor_id" = "home_player_id" THEN "away_player_id"
    ELSE "home_player_id"
    END
  SQL

  belongs_to :home_player, class_name: "Player"
  belongs_to :away_player, class_name: "Player"
  belongs_to :victor, class_name: "Player"
  belongs_to :table

  enum first_service: { first_service_by_home_player: 1, first_service_by_away_player: 2 }

  has_many :points, dependent: :destroy

  has_one :season_match, dependent: :destroy
  has_one :season, through: :season_match
  has_one :betting_info, dependent: :destroy

  validates :home_player, :away_player, :table, presence: true

  after_create :record_odds

  scope :ongoing, -> { where finalized_at: nil }
  scope :finalized, -> { where.not finalized_at: nil }
  scope :with_player, ->(player) {
    finalized.where("home_player_id = :player OR away_player_id = :player",
                    player: player)
  }

  def self.setup!(matchup = nil, table: Table.default)
    matchup ||= Matchmaker.choose
    return unless matchup.valid?

    player1, player2 = *matchup.players.sort_by(&:name)

    player1_at_home = player1.matches_against(player2).none? ||
                      player1.matches_against(player2).
                      order(created_at: :asc).last.away_player == player1

    match = if player1_at_home
              Match.create!(
                home_player: player1,
                away_player: player2,
                table: table
              )
            else
              Match.create!(
                home_player: player2,
                away_player: player1,
                table: table
              )
            end

    ongoing_season = Season.ongoing.first
    if ongoing_season && ongoing_season.eligible?(matchup)
      match.season = ongoing_season
    end

    match
  end

  def league_match?
    !!season
  end

  def all_matches_before
    Match.where('id < ?', id)
  end

  def to_matchup
    Matchup.new(home_player, away_player)
  end

  def players
    [home_player, away_player]
  end

  def home_points
    points.where(victor: home_player)
  end

  def away_points
    points.where(victor: away_player)
  end

  def finalize!
    self.finalized_at = Time.zone.now
    save
  end

  def finalized?
    !!finalized_at
  end

  def home_score
    home_points.count
  end

  def away_score
    away_points.count
  end

  def first_service_by=(player)
    if player == home_player
      first_service_by_home_player!
    elsif player == away_player
      first_service_by_away_player!
    else
      fail ArgumentError
    end
  end

  def toggle_service
    if first_service_by_home_player?
      first_service_by_away_player!
    else
      first_service_by_home_player!
    end
  end

  def loser
    Player.find(([home_player_id, away_player_id] - [victor_id]).first)
  end

  def finished?
    highest_score > 10 && (away_score - home_score).abs >= 2
  end

  def highest_score
    [home_score, away_score].max
  end

  def home_player_service?
    return unless first_service
    points_count = points.count
    first_service_by_away_player? ^ (points_count >= 20 ? points_count : points_count / 2).even?
  end

  def away_player_service?
    return unless first_service
    !home_player_service?
  end

  def leader
    return nil if home_score == away_score
    home_score > away_score ? home_player : away_player
  end

  def trailer
    return nil if home_score == away_score
    home_score < away_score ? home_player : away_player
  end

  def leading_score
    highest_score unless score_differential == 0
  end

  def trailing_score
    [home_score, away_score].min unless score_differential == 0
  end

  def game_point
    return if finished?
    if highest_score >= 10 && score_differential > 0
      leader == home_player ? :home : :away
    end
  end

  def score_differential
    (away_score - home_score).abs
  end

  def warmup?
    first_service.nil? && warmup_seconds_left > 0
  end

  def warmup_seconds_left
    [90 - (Time.zone.now - created_at).to_i, 0].max
  end

  private

  def record_odds
    if home_player.matches_against(away_player).count >= Betting::MINIMUM_MATCH_COUNT
      create_betting_info!
    end
  end
end
