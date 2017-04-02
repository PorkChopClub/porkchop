class EloRating < ActiveRecord::Base
  belongs_to :player
  belongs_to :match

  validates :player,
            :rating,
            :match,
            presence: true

  class << self
    def most_recent_rating
      order(created_at: :desc).limit(1).pluck(:rating)[0]
    end

    def rating_on(date)
      where("created_at <= ?", date.end_of_day).most_recent_rating
    end

    def sorted_ratings
      order(:created_at).pluck(:rating)
    end
  end
end
