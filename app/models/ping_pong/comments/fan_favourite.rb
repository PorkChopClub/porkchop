module PingPong::Comments
  class FanFavourite < PingPong::Comment
    FAN_FAVOURITE_NAME = "Adam Mueller"

    def available?
      score_differential >= 3 &&
        players.map(&:name).include?(FAN_FAVOURITE_NAME) &&
        leader.name != FAN_FAVOURITE_NAME
    end

    def priority
      [score_differential - 2, 5].min
    end

    def message
      case score_differential
      when 3..4
        "Don't worry about it, Adam. Keep your head in the game."
      when 4..6
        "Alright Adam, bring this one back."
      when 7..9
        "Go Adam! It's comeback time!"
      else
        "Sorry Adam. You're fucked."
      end
    end

    private

    delegate(:players,
             :leader,
             :score_differential,
             to: :match)
  end
end
