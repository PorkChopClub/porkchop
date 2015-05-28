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
    Matchup.all(players: players).min_by do |matchup|
      matchup.last_played_at.to_i +
        matchup.home_player.last_played_at.to_i +
        matchup.away_player.last_played_at.to_i
    end || Matchup.new(home_player: nil, away_player: nil)
  end
end
