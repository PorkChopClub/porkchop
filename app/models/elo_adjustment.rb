class EloAdjustment
  def initialize(victor:, loser:)
    @victor = victor
    @loser = loser
    @victor_player = Elo::Player.new(rating: victor.elo)
    @loser_player = Elo::Player.new(rating: loser.elo)
  end

  def adjust!
    victor_player.wins_from(loser_player)
    victor.elo = victor_player.rating
    loser.elo = loser_player.rating
    victor.save!
    loser.save!
  end

  private

  attr_reader :victor,
              :loser,
              :victor_player,
              :loser_player
end
