class Matchmaker
  class RankedMatchup
    class_attribute :current_time

    attr_reader :matchup

    def initialize(matchup)
      @matchup = matchup
    end

    def rank
      seconds_since(matchup.last_played_at) +
        seconds_since(home_player.last_played_at) +
        seconds_since(away_player.last_played_at)
    end

    private

    delegate :home_player,
             :away_player,
             to: :matchup

    def seconds_since(date_time)
      current_time.to_i - date_time.to_i
    end
  end

  attr_reader :players

  EPOCH = Time.at(0)

  def initialize(players)
    @players = players.to_a
  end

  def self.choose
    new(Player.active).choose
  end

  def choose
    highest_ranked_match || empty_match
  end

  private

  def highest_ranked_match
    RankedMatchup.current_time = Time.zone.now

    Matchup.all(players: players).
      map { |matchup| RankedMatchup.new(matchup) }.
      max_by(&:rank).try(:matchup)
  end

  def empty_match
    Matchup.new(home_player: nil, away_player: nil)
  end
end
