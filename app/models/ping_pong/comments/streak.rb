module PingPong::Comments
  class Streak < PingPong::Comment
    def available?
      !points.empty? && streak_length > 2
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
      ordered_points.chunk(&:victor).to_a[0][1].size
    end

    def streaker
      ordered_points.first.victor
    end

    def ordered_points
      points.order(created_at: :desc)
    end
  end
end
