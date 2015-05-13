module PingPong::Comments
  class WarmUp < PingPong::Comment
    TIME_LIMIT_SECONDS = 90

    def available?
      match.first_service.nil?
    end

    def priority
      10
    end

    def message
      if seconds_since_creation <= TIME_LIMIT_SECONDS
        Time.
          at(TIME_LIMIT_SECONDS - seconds_since_creation).
          utc.strftime("%M:%S")
      else
        "Time to play!"
      end
    end

    private

    delegate :home_player,
             :away_player,
             to: :match

    def seconds_since_creation
      @seconds_since_creation ||= (Time.zone.now - match.created_at.to_time).to_i
    end
  end
end
