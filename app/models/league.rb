class League < ActiveRecord::Base
  has_many :seasons
  belongs_to :table

  validates :name, :table, presence: true
end
