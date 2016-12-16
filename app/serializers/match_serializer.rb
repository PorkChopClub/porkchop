class MatchSerializer < ActiveModel::Serializer
  attributes :id,
             :home_score,
             :away_score

  belongs_to :home_player
  belongs_to :away_player
end
