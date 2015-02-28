class PingPong::Finalization
  def initialize match
    @match = match
  end

  def finalize!
    return true if match.finalized?
    return false unless match.finished?
    match.victor = match.leader
    match.finalize!
    # NOTE: ActiveJob canot serialize a PingPong::Match.
    MatchFinalizationJob.perform_later match.__getobj__
    true
  end

  private
  attr_reader :match
end

