class Season < ActiveRecord::Base
  validates :games_per_matchup, numericality: { greater_than: 0 }

  has_many :season_memberships
  has_many :players, through: :season_memberships

  def finalize!
    touch(:finalized_at) unless finalized_at
  end
end
