class Api::StatsController < ApplicationController
  def win_percentage
    authorize! :read, Player
    @percentages = Hash[
      Player.all.map do |player|
        [player.name, Stats::Personal.new(player).win_ratio]
      end
    ]
  end

  def rating
    authorize! :read, Player
    @ratings = Hash[
      Player.all.
      select { |p| p.matches.finalized.count >= 20 }.
      sort_by(&:elo).
      reverse.
      map { |p| [p.name, p.elo] }
    ]
  end
end
