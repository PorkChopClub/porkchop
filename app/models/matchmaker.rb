class Matchmaker
  class RankedMatchup
    class Term < Struct.new(:name, :base_value, :factor)
      def value
        base_value * factor
      end
    end

    class_attribute :current_time

    attr_reader :matchup,
                :terms

    def initialize(matchup)
      @matchup = matchup
      @terms = []

      add_term(name: "Matches since last played",
               base_value: matches_since_last_played)
    end

    def rank
      terms.sum(&:value)
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

    delegate :matches_since_last_played, to: :matchup

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
