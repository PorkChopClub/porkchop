module Stats
  class Streak < ActiveRecord::Base
    belongs_to :player
    validates :streak_type, :streak_length, presence: true
    validates :streak_type, inclusion: { in: %w(W L) }

    scope :active, -> { where finished_at: nil }
  end
end
