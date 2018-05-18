class MatchupSerializer < ActiveModel::Serializer
  attribute :player_names

  def player_names
    ordered_players.map(&:name)
  end

  private

  attr_reader :player1, :player2

  def ordered_players
    return [] unless object.players.any?
    @player1, @player2 = *object.players.sort_by(&:name)
    player1_at_home? ? [player1, player2] : [player2, player1]
  end

  def player1_at_home?
    return false unless object.players.any?
    player1_at_home = player1.matches_against(player2, finalized: false).none? ||
                      player1.matches_against(player2, finalized: false).
                      order(created_at: :asc).last.away_player == player1
  end
end
