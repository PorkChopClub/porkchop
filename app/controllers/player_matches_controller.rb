class PlayerMatchesController < ApplicationController
  def index
    @player = Player.find(params[:player_id])
    @matches = @player.matches.finalized.order(finalized_at: :desc)
    authorize! :read, @player
    authorize! :read, @matches
  end
end
