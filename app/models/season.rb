class Season < ActiveRecord::Base
  validates :games_per_matchup, numericality: { greater_than: 0, even: true }

  belongs_to :league

  has_many :season_memberships
  has_many :players, through: :season_memberships

  has_many :season_matches
  has_many :matches, through: :season_matches

  scope :ongoing, -> { where finalized_at: nil }

  def remaining_matchups
    Hash[matchups.map do |matchup|
      [matchup, games_per_matchup - matchup_count(matchup)]
    end]
  end

  def remaining_match_count
    total_match_count - matches.finalized.count
  end

  def eligible?(matchup)
    matches.to_a.count do |match|
      match.to_matchup == matchup
    end < games_per_matchup && (matchup.players - players).empty?
  end

  def finalize!
    touch(:finalized_at) unless finalized_at
  end

  def stats
    Stats::Season.new(self)
  end

  private

  def matchups
    Matchup.all(players: players)
  end

  def matchup_count(matchup)
    ids = matchup.players.map(&:id)
    match_counts_by_player_ids[ids] + match_counts_by_player_ids[ids.reverse]
  end

  def match_counts_by_player_ids
    @match_counts_by_player_ids ||=
      begin
        hash = Hash.new(0)
        hash.update matches.group(:home_player_id, :away_player_id).count
        hash
      end
  end

  def total_match_count
    (players.count**2 - players.count) * games_per_matchup / 2
  end
end
