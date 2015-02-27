class Match < ActiveRecord::Base
  belongs_to :home_player, class_name: "Player"
  belongs_to :away_player, class_name: "Player"
  belongs_to :victor, class_name: "Player"

  has_many :points, dependent: :destroy

  validates :home_player, :away_player, presence: true

  scope :ongoing, -> { where finalized_at: nil }
  scope :finalized, -> { where.not finalized_at: nil }

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

  def first_service_by_away_player?
    !first_service_by_home_player?
  end

  def loser
    Player.find ([home_player_id, away_player_id] - [victor_id]).first
  end
end
