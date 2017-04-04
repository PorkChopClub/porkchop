class TimelineEvent < ApplicationRecord
  belongs_to :match
  belongs_to :player

  enum event_type: {
    close_match: 1,
    upset: 2
  }

  validates :match,
            :event_type,
            presence: true
end
