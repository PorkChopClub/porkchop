class Table < ApplicationRecord
  DEFAULT_TABLE_NAME = "Stembolt Courtney".freeze

  class << self
    def default
      Table.find_by(name: DEFAULT_TABLE_NAME)
    end
  end

  has_many :matches

  validates :name, presence: true

  # NOTE: The active flag on players (at the time of this writing) means
  # "active on the default table." It is not possible to be active on other
  # tables.
  def active_players
    name == DEFAULT_TABLE_NAME ? Player.active : Player.none
  end

  def ongoing_match
    matches.ongoing.order(:created_at).first
  end

  def upcoming_matches
    matches.ongoing.order(:created_at).offset(1)
  end
end
