class Matchmaker
  attr_reader :players

  EPOCH = Time.at(0)

  def initialize(players)
    @players = players.to_a
  end

  def self.choose
    new(Player.active).choose
  end

  def choose
    home_player = players.min_by{ |player| player.last_played_at || EPOCH }
    away_player = (players - [home_player]).sample
    [home_player, away_player]
  end
end
