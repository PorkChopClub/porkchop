module PingPong::Comments
  class PreviousRecord < PingPong::Comment
    def available?
      match.points.count == 1
    end

    def priority
      5
    end

    def message
      "#{home_player.name} is #{record} against #{away_player.name}."
    end

    private

    delegate :home_player,
             :away_player,
             to: :match

    def record
      Stats::Personal.new(home_player).record_against(away_player).join('-')
    end
  end
end
