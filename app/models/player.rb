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

  def matches_against opponent
    matches.where(
      "away_player_id = :opponent OR home_player_id = :opponent",
      opponent: opponent
    )
  end

  def opponents
    Player.where(id: opponent_ids)
  end

  validates :name, presence: true

  private

  def opponent_ids
    matches.
      finalized.
      pluck(:away_player_id, :home_player_id).
      flatten.
      reject { |player_id| player_id == id }
  end
end
