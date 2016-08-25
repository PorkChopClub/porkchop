class Stats::Season
  attr_reader :season

  def initialize(season)
    @season = season
  end

  def players
    season.players.map do |player|
      Stats::SeasonPersonal.new(season, player)
    end.sort.reverse
  end
end
