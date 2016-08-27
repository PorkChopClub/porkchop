class PlayerMatchesController < ApplicationController
  def index
    @player = Player.find(params[:player_id])
    @matches = @player.matches.finalized.order(finalized_at: :desc).page(params[:page]).per(50)
    authorize! :read, @player
    authorize! :read, @matches
  end
end
