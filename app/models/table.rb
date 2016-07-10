class Table < ApplicationRecord
  DEFAULT_TABLE_NAME = "Stembolt Langley".freeze

  class << self
    def default
      Table.find_by(name: DEFAULT_TABLE_NAME)
    end
  end

  validates :name, presence: true
end
