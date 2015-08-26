module PingPong::Comments
  class Victory < PingPong::Comment
    def available?
      match.finished?
    end

    def priority
      100
    end

    def message
      "#{match.leader.name} Wins!"
    end
  end
end
