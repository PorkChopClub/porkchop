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
    [home_player, away_player]
  end

  private

  def home_player
    @home_player ||= players.min_by{ |player| player.last_played_at || EPOCH }
  end

  def away_player
    if possible_opponents.size == 1
      possible_opponents.first
    else
      possible_opponents.sort_by do |player|
        last_played_against(player) || EPOCH
      end.last(2).min_by do |player|
        player.last_played_at || EPOCH
      end
    end
  end

  def possible_opponents
    @possible_opponents ||= players - [home_player]
  end

  def last_played_against(player)
    home_player.matches_against(player).minimum(:created_at)
  end
end
