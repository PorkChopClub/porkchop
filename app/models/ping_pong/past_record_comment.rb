module PingPong
  class PastRecordComment < Comment
    def available?
      match.points.count < 2
    end

    def priority
      5 - match.points.count
    end

    def message
      if last_match
        "In their last match, #{last_match.victor.name} won #{[last_match.home_score, last_match.away_score].sort.reverse.join('-')}."
      else
        "This is the first match between these players."
      end
    end

    private
    delegate :home_player,
             :away_player,
             to: :match

    def last_match
      home_player.matches_against(away_player).
        order('finalized_at DESC').first
    end
  end
end
