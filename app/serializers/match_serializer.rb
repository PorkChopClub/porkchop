class MatchSerializer < ActiveModel::Serializer
  attributes :id,
             :home_score,
             :away_score,
             :first_service

  belongs_to :home_player
  belongs_to :away_player

  has_many :points
end
