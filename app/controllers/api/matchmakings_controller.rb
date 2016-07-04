class Api::MatchmakingsController < ApplicationController
  def show
    authorize! :read, Player
    render json: Matchmaker.new(Player.active).explain
  end
end
