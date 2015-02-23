class PingPong::Match < SimpleDelegator
  def home_player_service?
    first_service_by_away_player? ^ (points.count / 2 % 2 == 0)
  end

  def finished?
    highest_score > 10 && score_differential >= 2
  end

  def leader
    return nil if home_score == away_score
    home_score > away_score ? home_player : away_player
  end

  private

  def highest_score
    [home_score, away_score].max
  end

  def score_differential
    (away_score - home_score).abs
  end
end
