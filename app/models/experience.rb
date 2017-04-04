class Experience < ApplicationRecord
  REASON_XP_VALUES = {
    "completed_match" => 100,
    "won_match" => 35
  }

  belongs_to :player
  belongs_to :match

  enum reason: {
    completed_match: 1,
    won_match: 2
  }

  before_validation :calculate_xp

  validates :player,
            :match,
            presence: true

  private

  def calculate_xp
    self.xp ||= REASON_XP_VALUES.fetch(reason)
  end
end
