class PlayerMatchesController < ApplicationController
  def index
    @player = Player.find(params[:player_id])
  end
end
