class Stats::SeasonPersonal
  include Comparable

  attr_reader :player

  def initialize(season, player)
    @season, @player = season, player
  end

  def <=>(other)
    [win_ratio, point_differential] <=> [other.win_ratio, other.point_differential]
  end

  def matches_played
    matches.count
  end

  def matches_won
    matches.where(victor_id: player.id).count
  end

  def matches_lost
    matches_played - matches_won
  end

  def win_ratio
    @win_ratio ||= format_ratio(matches_won, matches_played)
  end

  def points_for
    points.where(victor_id: player.id).count
  end

  def points_against
    points.where.not(victor_id: player.id).count
  end

  def point_differential
    points_for - points_against
  end

  def games_back
    player_records = season.players.map do |player|
      [
        player.id,
        [
          season.matches.with_player(player).where(victor: player).count,
          season.matches.with_player(player).where.not(victor: player).count
        ]
      ]
    end.to_h

    GamesBack.calculate(player_records)[player.id]
  end

  private

  attr_reader :season

  def matches
    @matches ||= season.matches.finalized.where("home_player_id = :player OR away_player_id = :player", player: player)
  end

  def points
    @points ||= Point.where(match: matches)
  end

  def format_ratio(numerator, denominator)
    if numerator.zero?
      ratio = 0
    else
      ratio = numerator.to_f / denominator.to_f
    end
    ("%.3f" % ratio).sub(/\A0/, "")
  end
end
