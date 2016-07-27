class MatchSerializer < ActiveModel::Serializer
  attributes :id, :home_score, :away_score, :table_id
end
