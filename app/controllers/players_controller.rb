class PlayersController < ApplicationController
  before_action :load_player, only: %i(show update)
  authorize_resource

  def index
    @players = Player.all.order(:name)
  end

  def show
    @stats = Stats::Personal.new(@player)
  end

  private

  def load_player
    @player = Player.find(params[:id])
  end

  def player_params
    params.require(:player).permit(:nickname)
  end
end
