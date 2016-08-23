class Matchmaker
  class RankedMatchup
    Term = Struct.new(:name, :base_value, :max, :factor) do
      def value
        [base_value, max].min * factor
      end
    end

    class_attribute :total_player_count

    attr_reader :matchup,
                :terms

    def initialize(matchup)
      @matchup = matchup
      @terms = []

      add_term(name: "Matchup matches since last played",
               base_value: matches_since_last_played,
               max: total_possible_matchups * 2.0,
               factor: 0.25 / total_possible_matchups)

      add_term(name: "Combined matches since players last played",
               base_value: players.sum(&:matches_since_last_played),
               max: (total_player_count - 1) * 2.0,
               factor: 2.0 / (total_player_count - 1))

      elo_difference = players.map(&:elo).inject(:-).abs
      base_value =
        if elo_difference < 300
          1.0
        else
          [300.0 / elo_difference, 0.25].max
        end

      add_term(name: "Difference in skill rating",
               base_value: base_value,
               max: 1.0,
               factor: 2.0)
    end

    def rank
      terms.sum(&:value)
    end

    def breakdown
      terms.map do |term|
        {
          name: term.name,
          base_value: term.base_value,
          max: term.max,
          factor: term.factor,
          value: term.value
        }
      end
    end

    private

    delegate :matches_since_last_played,
             :players,
             to: :matchup

    def total_possible_matchups
      total_player_count * (total_player_count - 1) / 2
    end

    def add_term(name:, base_value:, max:, factor: 1)
      terms << Term.new(name, base_value, max, factor)
    end
  end

  attr_reader :players

  EPOCH = Time.zone.at(0)

  def initialize(players)
    @players = players.to_a
  end

  def self.choose
    # matchmaking is dependent on the currently active players, and all matches
    # played. We cache the choice under this key.
    last_match = Match.last
    cache_key = "matchmaker/#{Player.active.map(&:id).sort.join('/')}/#{last_match.cache_key if last_match}"
    Rails.cache.fetch(cache_key) do
      new(Player.active).choose
    end
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
