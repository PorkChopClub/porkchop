class EloRating < ActiveRecord::Base
  belongs_to :player
  validates :player,
            :rating,
            presence: true

  def self.most_recent_rating
    self.order(created_at: :desc).pluck(:rating).first
  end
end
