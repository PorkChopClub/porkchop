module PingPong
  class Comment
    def initialize match
      @match = match
    end

    def priority
      0
    end

    def available?
      true
    end

    def message
      raise NotImplementedError
    end

    private
    attr_reader :match
  end
end
