class Api::MatchmakingsController < ApplicationController
  def show
    render json: Matchmaker.new(Player.active).explain
  end
end
