module PingPong
  class Service
    def initialize match:, victor:
      @match = match
      @victor = victor
    end

    def record!
      return false if @match.finished?
      @match.points.create! victor: @victor
    end
  end
end
