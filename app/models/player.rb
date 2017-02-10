class Player < ActiveRecord::Base
  BASE_ELO = 1000

  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :trackable,
         :validatable

  mount_uploader :profile_picture, ProfilePictureUploader

  scope :active, -> { where(active: true) }

  has_many :points, foreign_key: 'victor_id'
  has_many :victories, class_name: "Match", foreign_key: 'victor_id'
  has_many :elo_ratings
  has_many :season_memberships
  has_many :seasons, through: :season_memberships
  has_many :streaks, class_name: "Stats::Streak"

  validates :name, presence: true

  after_save :record_rating

  def self.ranked
    joins('INNER JOIN "matches" ON ("home_player_id" = "players"."id" OR "away_player_id" = "players"."id")').
      group('"players"."id"').
      having(%{SUM(CASE WHEN finalized_at > '#{14.days.ago.to_s :db}' THEN 1 ELSE 0 END) > 4 AND COUNT(*) >= 20}).
      order(%{(SELECT rating FROM "elo_ratings" WHERE player_id = "players"."id" ORDER BY "elo_ratings"."created_at" DESC LIMIT 1 ) DESC})
  end

  def matches
    Match.where "matches.home_player_id = :id OR matches.away_player_id = :id",
                id: id
  end

  def losses
    matches.finalized.where.not(victor: self)
  end

  def matches_since_last_played
    if last_played_at = matches.order(created_at: :asc).last.try(:created_at)
      Match.where("created_at > ?", last_played_at).count
    else
      Float::INFINITY
    end
  end

  def matches_against(opponent)
    matches.finalized.where(
      "away_player_id = :opponent OR home_player_id = :opponent",
      opponent: opponent
    )
  end

  def opponents
    Player.where(id: opponent_ids)
  end

  attr_writer :elo

  def elo
    elo_ratings.most_recent_rating || BASE_ELO
  end

  def elo_on(date)
    elo_ratings.rating_on(date) || BASE_ELO
  end

  def last_played_at
    matches.maximum(:created_at) || Time.zone.at(0)
  end

  def stats
    @stats ||= Stats::Personal.new(self)
  end

  def current_streak
    streaks.active.first
  end

  def retired?
    matches.finalized.where('finalized_at > ?', 4.months.ago).count < 10
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
