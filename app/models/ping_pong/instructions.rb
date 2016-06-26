module PingPong
  class Instructions < Comment
    def message
      if match.finished? && !match.finalized?
        "Press to finalize"
      elsif match.warmup?
        "Waiting for match to start"
      elsif !match.first_service
        "Select first service"
      end
    end
  end
end
