class EloAdjustment
  def initialize(victor:, loser:, match:)
    @victor = victor
    @loser = loser
    @match = match
  end

  def adjust!
    calculate!

    [
      victor.elo_ratings.create!(rating: victor_rating, match: match),
      loser.elo_ratings.create!(rating: loser_rating, match: match)
    ]
  end

  private

  attr_reader :victor, :loser, :match

  def calculate!
    victor_player.wins_from(loser_player)
  end

  def victor_player
    @victor_player ||= Elo::Player.new(
      rating: victor.elo,
      games_played: prior_match_count(player: victor)
    )
  end

  def loser_player
    @loser_player ||= Elo::Player.new(
      rating: loser.elo,
      games_played: prior_match_count(player: loser)
    )
  end

  def victor_rating
    victor_player.rating
  end

  def loser_rating
    loser_player.rating
  end

  def prior_match_count(player:)
    match.all_matches_before.merge(player.matches).count
  end
end
