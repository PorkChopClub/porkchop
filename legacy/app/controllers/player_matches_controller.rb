class PlayerMatchesController < ApplicationController
  load_and_authorize_resource class: Player

  def index
    @player = Player.find(params[:player_id])
  end
end
