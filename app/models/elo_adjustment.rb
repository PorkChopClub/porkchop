class EloAdjustment
  def initialize(victor:, loser:)
    @victor = victor
    @loser = loser
    @victor_player = Elo::Player.new(rating: victor.elo)
    @loser_player = Elo::Player.new(rating: loser.elo)
  end

  def adjust!
    calculate
    victor.elo = victor_player.rating
    loser.elo = loser_player.rating
    victor.save!
    loser.save!
  end

  def victor_elo_change
    calculate
    victor_player.rating - victor.elo
  end

  def loser_elo_change
    calculate
    loser_player.rating - loser.elo
  end

  private

  attr_reader :victor,
              :loser,
              :victor_player,
              :loser_player

  def calculate
    @calculate ||= victor_player.wins_from(loser_player)
  end
end
