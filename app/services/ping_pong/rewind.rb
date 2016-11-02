class PingPong::Rewind
  def initialize(match)
    @match = match
  end

  def rewind!
    return false if match.finalized? || no_points?
    match.points.last.destroy
    true
  end

  private

  attr_reader :match

  def no_points?
    match.points.count == 0
  end
end
