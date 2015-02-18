class Api::StatsController < ApplicationController
  def win_percentage
    @percentages = Player.all.to_a.inject({}) { |acc, player|
      acc[player.name] = win_percentage_of player
      acc
    }
  end

  private

  def win_percentage_of player
    if player.matches.count != 0
      (player.victories.count/player.matches.count.to_f).round(3)
    else
      0.0
    end
  end
end
