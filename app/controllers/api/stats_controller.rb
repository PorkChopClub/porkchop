class Api::StatsController < ApplicationController
  skip_authorization_check

  def win_percentage
    @percentages = Player.all.to_a.inject({}) { |acc, player|
      acc[player.name] = Stats::Personal.new(player).win_ratio
      acc
    }
  end

  def rating
    @ratings = Hash[
      Player.all.
      select { |p| p.matches.finalized.count >= 20 }.
      sort_by(&:elo).
      reverse.
      map { |p| [p.name, p.elo] }
    ]
  end
end
