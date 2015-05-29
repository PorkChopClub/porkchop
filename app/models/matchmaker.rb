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
    Matchup.all(players: players).max_by do |matchup|
      (now - matchup.last_played_at.to_i) +
        (now - matchup.home_player.last_played_at.to_i) +
        (now - matchup.away_player.last_played_at.to_i)
    end || Matchup.new(home_player: nil, away_player: nil)
  end

  private

  def now
    @now ||= Time.zone.now.to_i
  end
end
