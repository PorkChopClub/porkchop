class Table < ApplicationRecord
  DEFAULT_TABLE_NAME = "Stembolt Courtney".freeze

  class << self
    def default
      Table.find_by(name: DEFAULT_TABLE_NAME)
    end
  end

  has_many :matches

  validates :name, presence: true

  def ongoing_match
    matches.ongoing.order(:created_at).first
  end

  def upcoming_matches
    matches.ongoing.order(created_at: :desc).offset(1)
  end
end
