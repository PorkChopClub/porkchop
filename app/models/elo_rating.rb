class EloRating < ActiveRecord::Base
  belongs_to :player
  validates :player,
            :rating,
            presence: true

  def self.most_recent_rating
    order(created_at: :desc).limit(1).pluck(:rating)[0]
  end

  def self.rating_on(date)
    where("created_at <= ?", date.end_of_day).most_recent_rating
  end

  def self.sorted_ratings
    order(:created_at).pluck(:rating)
  end
end
