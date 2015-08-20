class Season < ActiveRecord::Base
  validates :games_per_matchup, numericality: { greater_than: 0, even: true }

  belongs_to :league

  has_many :season_memberships
  has_many :players, through: :season_memberships

  has_many :season_matches
  has_many :matches, through: :season_matches

  scope :ongoing, -> { where finalized_at: nil }

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

  private

  def total_match_count
    (players.count ** 2 - players.count) * games_per_matchup / 2
  end
end
