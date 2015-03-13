class EloRating < ActiveRecord::Base
  belongs_to :player
  validates :player,
            :rating,
            presence: true
end
