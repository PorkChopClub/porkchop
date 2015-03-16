module PingPong
  class Service
    def initialize(match:, victor:)
      @match = match
      @victor = victor
    end

    def record!
      if @match.finished?
        false
      elsif !@match.first_service
        # This is a rally for service, winner has first serve
        @match.first_service_by = @victor
      else
        # Record this point for the winner
        @match.points.create! victor: @victor
      end
    end
  end
end
