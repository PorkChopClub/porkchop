class Api::StatsController < ApplicationController
  skip_authorization_check

  def win_percentage
    @percentages = Player.all.to_a.inject({}) { |acc, player|
      acc[player.name] = Stats::Personal.new(player).win_ratio
      acc
    }
  end
end
