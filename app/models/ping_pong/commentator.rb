module PingPong
  class Commentator
    COMMENT_CLASSES = [PingPong::PastRecordComment]

    def initialize(match:)
      @match = match
    end

    def comment
      comments.select(&:available?).max_by(&:priority).message
    end

    private
    attr_reader :match

    def comments
      COMMENT_CLASSES.map { |klass| klass.new(match) }
    end
  end
end
