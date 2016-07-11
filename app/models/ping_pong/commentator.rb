module PingPong
  class Commentator
    COMMENT_CLASSES = [
      PingPong::Comments::FanFavourite,
      PingPong::Comments::GamePoint,
      PingPong::Comments::LastGame,
      PingPong::Comments::PreviousRecord,
      PingPong::Comments::Streak,
      PingPong::Comments::Victory,
      PingPong::Comments::WarmUp
    ].freeze

    def initialize(match:)
      @match = match
    end

    def comment
      comments.select(&:available?).max_by(&:priority).try(:message)
    end

    def instructions
      Instructions.new(match).message
    end

    private

    attr_reader :match

    def comments
      COMMENT_CLASSES.map { |klass| klass.new(match) }
    end
  end
end
