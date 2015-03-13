class Player < ActiveRecord::Base
  BASE_ELO = 1000

  has_many :points, foreign_key: 'victor_id'
  has_many :victories, class_name: "Match", foreign_key: 'victor_id'
  has_many :elo_ratings

  validates :name, presence: true

  after_save :record_rating

  has_many :achievements

  def matches
    Match.where "matches.home_player_id = :id OR matches.away_player_id = :id",
      id: id
  end

  def losses
    matches.finalized.where.not(victor: self)
  end

  def matches_against opponent
    matches.finalized.where(
      "away_player_id = :opponent OR home_player_id = :opponent",
      opponent: opponent
    )
  end

  def opponents
    Player.where(id: opponent_ids)
  end

  def elo= rating
    @elo = rating
  end

  def elo
    elo_ratings.most_recent_rating || BASE_ELO
  end

  private

  def record_rating
    return unless @elo
    elo_ratings.create(rating: @elo)
  end

  def opponent_ids
    matches.
      finalized.
      pluck(:away_player_id, :home_player_id).
      flatten.
      reject { |player_id| player_id == id }
  end
end
