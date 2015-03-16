class PingPong::Match < SimpleDelegator
  delegate :comment, :instructions, to: :commentator

  def home_player_service?
    return unless first_service
    first_service_by_away_player? ^ (points.count / 2 % 2 == 0)
  end

  def away_player_service?
    return unless first_service
    !home_player_service?
  end

  def finished?
    highest_score > 10 && score_differential >= 2
  end

  def leader
    return nil if home_score == away_score
    home_score > away_score ? home_player : away_player
  end

  def game_point
    return if finished?
    if highest_score >= 10 && score_differential > 0
      leader == home_player ? :home : :away
    end
  end

  private

  def commentator
    @commentator ||= PingPong::Commentator.new(match: self)
  end

  def highest_score
    [home_score, away_score].max
  end

  def score_differential
    (away_score - home_score).abs
  end
end
