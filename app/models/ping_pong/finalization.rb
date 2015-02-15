class PingPong::Finalization
  def initialize match
    @match = match
  end

  def finalize!
    return true if match.finalized?
    return false unless match.finished?
    match.victor = match.leader
    match.finalize!
  end

  private
  attr_reader :match
end
