class Match < ActiveRecord::Base
  belongs_to :home_player, class_name: "Player"
  belongs_to :away_player, class_name: "Player"
  belongs_to :victor, class_name: "Player"

  enum first_service: { first_service_by_home_player: 1, first_service_by_away_player: 2 }

  has_many :points, dependent: :destroy

  has_one :season_match, dependent: :destroy
  has_one :season, through: :season_match
  has_one :betting_info, dependent: :destroy

  validates :home_player, :away_player, presence: true

  after_create :record_odds

  scope :ongoing, -> { where finalized_at: nil }
  scope :finalized, -> { where.not finalized_at: nil }

  def self.setup!(matchup = nil)
    matchup ||= Matchmaker.choose
    return unless matchup.valid?

    player1, player2 = *matchup.players.sort_by(&:name)

    player1_at_home = player1.matches_against(player2).none? ||
                      player1.matches_against(player2).
                      order(created_at: :asc).last.away_player == player1

    match = if player1_at_home
              Match.create!(
                home_player: player1,
                away_player: player2
              )
            else
              Match.create!(
                home_player: player2,
                away_player: player1
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

  private

  def record_odds
    if home_player.matches_against(away_player).count >= Betting::MINIMUM_MATCH_COUNT
      create_betting_info!
    end
  end
end
