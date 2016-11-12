class Stats::Season
  attr_reader :season

  def initialize(season)
    @season = season
  end

  def players
    season.players.map do |player|
      Stats::SeasonPersonal.new(self, player)
    end.sort.reverse
  end

  MATCH_WINNER_SQL = '"victor_id"'.freeze
  MATCH_LOSER_SQL = 'CASE WHEN "victor_id" = "home_player_id" THEN "away_player_id" ELSE "home_player_id" END'.freeze

  def matches_won_by_player
    @matches_won_by_player ||= default_zero matches.group(Match::WINNER_SQL).count
  end

  def matches_lost_by_player
    @matches_lost_by_player ||= default_zero matches.group(Match::LOSER_SQL).count
  end

  POINT_FOR_SQL = '"points"."victor_id"'.freeze
  POINT_AGAINST_SQL = <<SQL.freeze
CASE WHEN "points"."victor_id" = "matches"."home_player_id" THEN away_player_id
     ELSE home_player_id
END
SQL

  def points_for_by_player
    @points_for_by_player ||= default_zero matches.joins(:points).group(POINT_FOR_SQL).count
  end

  def points_against_by_player
    @poins_against_by_player ||= default_zero matches.joins(:points).group(POINT_AGAINST_SQL).count
  end

  def games_back_by_player
    @games_back_by_player ||=
      begin
        player_records = season.players.map do |player|
          [
            player.id,
            [
              matches_won_by_player[player.id],
              matches_lost_by_player[player.id]
            ]
          ]
        end.to_h

        GamesBack.calculate(player_records)
      end
  end

  private

  def matches
    season.matches
  end

  def default_zero(hash)
    Hash.new(0).update hash
  end
end
