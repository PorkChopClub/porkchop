module Betting
  class Spread
    def initialize(away_player:, home_player:)
      @home_player = home_player
      @away_player = away_player
      @matches =
        home_player.
        matches_against(away_player).
        order(created_at: :desc).
        limit(Betting::MINIMUM_MATCH_COUNT)
    end

    def spread
      return if match_count < Betting::MINIMUM_MATCH_COUNT
      (raw_spread.abs - 0.5).round + 0.5
    end

    def favourite
      return if match_count < Betting::MINIMUM_MATCH_COUNT
      if raw_spread > 0
        home_player
      else
        away_player
      end
    end

    private

    attr_reader :home_player, :away_player, :matches

    def match_count
      @match_count ||= matches.count
    end

    def raw_spread
      @raw_spread ||= matches.map do |match|
        if match.home_player == home_player
          match.home_score - match.away_score
        else
          match.away_score - match.home_score
        end
      end.map(&:to_f).sum / match_count
    end
  end
end
