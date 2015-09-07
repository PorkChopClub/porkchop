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

  def to_builder
    Jbuilder.new do |match|
      match.id to_param

      match.home_score home_score
      match.home_player_name home_player.try(:name)
      match.home_player_nickname home_player.try(:nickname)
      match.home_player_avatar_url home_player.try(:avatar_url)

      match.away_score away_score
      match.away_player_name away_player.try(:name)
      match.away_player_nickname away_player.try(:nickname)
      match.away_player_avatar_url away_player.try(:avatar_url)

      match.home_player_service !!home_player_service?
      match.away_player_service !!away_player_service?
      match.finished finished?
      match.finalized finalized?
      match.deleted destroyed?
      match.league_match league_match?
      match.comment comment || ""
      match.instructions instructions || ""
    end
  end

  private

  def commentator
    @commentator ||= PingPong::Commentator.new(match: self)
  end

  def highest_score
    [home_score, away_score].max
  end
end
