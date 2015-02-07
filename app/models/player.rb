class Player < ActiveRecord::Base
  has_many :points, foreign_key: 'victor_id'

  validates :name, presence: true
end
