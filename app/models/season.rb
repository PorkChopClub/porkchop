class Season < ActiveRecord::Base
  validates :games_per_matchup, numericality: { greater_than: 0, even: true }

  has_many :season_memberships
  has_many :players, through: :season_memberships

  has_many :season_matches
  has_many :matches, through: :season_matches

  scope :ongiong, -> { where finalized_at: nil }

  def finalize!
    touch(:finalized_at) unless finalized_at
  end
end
