class PingPong::Finalization
  def initialize(match)
    @match = match
  end

  def finalize!(async: true)
    return true if match.finalized?
    return false unless match.finished?
    match.victor = match.leader
    match.finalize!
    # NOTE: ActiveJob canot serialize a PingPong::Match.
    if async
      MatchFinalizationJob.perform_later match.__getobj__
    else
      MatchFinalizationJob.perform_now match.__getobj__
    end
    true
  end

  private

  attr_reader :match
end
