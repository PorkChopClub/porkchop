class Player < ActiveRecord::Base
  has_many :points, foreign_key: 'victor_id'
  has_many :victories, class_name: "Match", foreign_key: 'victor_id'

  def matches
    Match.where "matches.home_player_id = :id OR matches.away_player_id = :id",
      id: id
  end

  def losses
    matches.finalized.where.not(victor: self)
  end

  validates :name, presence: true
end
