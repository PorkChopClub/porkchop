module Stats
  class SeasonPersonal
    include Comparable

    attr_reader :player

    def initialize(season_stats, player)
      @season_stats, @player = season_stats, player
    end

    def <=>(other)
      [win_ratio, point_differential] <=> [other.win_ratio, other.point_differential]
    end

    def matches_played
      matches_won + matches_lost
    end

    def matches_won
      season_stats.matches_won_by_player[player.id]
    end

    def matches_lost
      season_stats.matches_lost_by_player[player.id]
    end

    def win_ratio
      @win_ratio ||= format_ratio(matches_won, matches_played)
    end

    def points_for
      season_stats.points_for_by_player[player.id]
    end

    def points_against
      season_stats.points_against_by_player[player.id]
    end

    def point_differential
      points_for - points_against
    end

    def games_back
      season_stats.games_back_by_player[player.id]
    end

    private

    attr_reader :season_stats
    delegate :season, to: :season_stats

    def format_ratio(numerator, denominator)
      ratio = numerator.zero? ? 0 : numerator.to_f / denominator.to_f
      ("%.3f" % ratio).sub(/\A0/, "")
    end
  end
end
