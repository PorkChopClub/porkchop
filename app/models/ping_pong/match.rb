class PingPong::Match < SimpleDelegator
  delegate :comment, :instructions, to: :commentator

  def home_player_service?
    return unless first_service
    points_count = points.count
    first_service_by_away_player? ^ (points_count >= 20 ? points_count : points_count / 2).even?
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

  def trailer
    return nil if home_score == away_score
    home_score < away_score ? home_player : away_player
  end

  def leading_score
    highest_score unless score_differential == 0
  end

  def trailing_score
    [home_score, away_score].min unless score_differential == 0
  end

  def game_point
    return if finished?
    if highest_score >= 10 && score_differential > 0
      leader == home_player ? :home : :away
    end
  end

  def score_differential
    (away_score - home_score).abs
  end

  def warmup?
    first_service.nil? && warmup_seconds_left > 0
  end

  def warmup_seconds_left
    [90 - (Time.zone.now - created_at).to_i, 0].max
  end

  private

  def commentator
    @commentator ||= PingPong::Commentator.new(match: self)
  end

  def highest_score
    [home_score, away_score].max
  end
end
