class Matchmaker
  class RankedMatchup
    class Term < Struct.new(:name, :base_value, :factor)
      def value
        base_value * factor
      end
    end

    class_attribute :current_time
    class_attribute :total_player_count

    attr_reader :matchup,
                :terms

    def initialize(matchup)
      @matchup = matchup
      @terms = []

      # A number between 0 and 2 representing which is higher the longer since
      # the match. This is essentially just a tie breaker.
      add_term(name: "Matchup matches since last played",
               base_value: 2.0 - 1.0 / [matches_since_last_played, 0.5].max)

      # 0, 10, or 20 based on whether 0, 1, or 2 players in the matchup should
      # have played by now.
      add_term(name: "Players who should have played by now",
               base_value: players_who_should_play,
               factor: 10.0)
    end

    def rank
      terms.sum(&:value)
    end

    def players_who_should_play
      players.select do |player|
        player.matches_since_last_played >= total_player_count / 2.0 - 1
      end.count
    end

    def breakdown
      terms.map do |term|
        {
          name: term.name,
          base_value: term.base_value,
          factor: term.factor,
          value: term.value
        }
      end
    end

    private

    delegate :matches_since_last_played,
             :players,
             to: :matchup

    def add_term(name:, base_value:, factor: 1)
      terms << Term.new(name, base_value, factor)
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

  def explain
    ranked_matchups.map do |ranked_matchup|
      matchup = ranked_matchup.matchup
      {
        players: matchup.players.map(&:name),
        result: ranked_matchup.rank,
        breakdown: ranked_matchup.breakdown
      }
    end
  end

  private

  def highest_ranked_match
    ranked_matchups.max_by(&:rank).try!(:matchup)
  end

  def ranked_matchups
    @ranked_matchups ||= begin
      RankedMatchup.current_time = Time.zone.now
      RankedMatchup.total_player_count = players.length

      Matchup.all(players: players).
        map { |matchup| RankedMatchup.new(matchup) }.
        sort_by(&:rank).
        reverse
    end
  end

  def empty_match
    Matchup.new
  end
end
