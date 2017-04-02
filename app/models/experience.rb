class Experience < ApplicationRecord
  belongs_to :player
  belongs_to :match

  enum reason: {
    completed_match: 1,
    won_match: 2
  }

  REASON_XP_VALUES = {
    completed_match: 25,
    won_match: 15
  }

  validates :player,
            :match,
            presence: true
end
