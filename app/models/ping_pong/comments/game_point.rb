module PingPong::Comments
  class GamePoint < PingPong::Comment
    def available?
      match.game_point
    end

    def priority
      10
    end

    def message
      "Game point, #{leader.name}."
    end

    attr_reader :match
    delegate :leader, to: :match
  end
end
