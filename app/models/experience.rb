class Experience < ApplicationRecord
  belongs_to :player
  belongs_to :source, polymorphic: true
  belongs_to :match

  validates :player,
            :source,
            :match,
            presence: true
end
