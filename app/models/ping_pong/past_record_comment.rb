module PingPong
  class PastRecordComment
    def initialize match
      @match = match
    end

    def available?
      true
    end

    def priority
      match.points.count < 2 ? 10 : 0
    end

    def message
      if last_match
        "In their last match, #{last_match.victor.name} won #{[last_match.home_score, last_match.away_score].sort.reverse.join('-')}."
      else
        "This is the first match between these players."
      end
    end

    private
    attr_reader :match
    delegate :home_player,
             :away_player,
             to: :match

    def last_match
      home_player.matches_against(away_player).
        order('finalized_at DESC').first
    end
  end
end
