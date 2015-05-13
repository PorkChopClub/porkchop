module PingPong::Comments
  class Streak < PingPong::Comment
    def available?
      points.length != 0 && streak_length > 2
    end

    def priority
      streak_length - 2
    end

    def message
      "#{streaker.name} is on a #{streak_length} point streak!"
    end

    private

    delegate :points, to: :match

    def streak_length
      points.chunk(&:victor).to_a[0][1].size
    end

    def streaker
      points.first.victor
    end
  end
end
