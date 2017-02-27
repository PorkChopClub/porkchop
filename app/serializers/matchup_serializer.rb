class MatchupSerializer < ActiveModel::Serializer
  attribute :player_names

  def player_names
    object.players.map(&:name)
  end
end
