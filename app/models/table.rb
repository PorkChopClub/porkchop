class Table < ApplicationRecord
  DEFAULT_TABLE_NAME = "Stembolt Langley"

  class << self
    def default
      Table.find_by(name: DEFAULT_TABLE_NAME)
    end
  end

  validates :name, presence: true
end
