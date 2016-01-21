class PlayersController < ApplicationController
  before_action :load_player, only: %i(show update edit)
  before_action :require_write_access, only: %i(update edit)

  def index
    @players = Player.all.order(:name)
  end

  def show
    @stats = Stats::Personal.new(@player)
  end

  def update
    if @player.update player_params
      redirect_to @player
    else
      render :edit
    end
  end

  private

  def load_player
    @player = Player.find(params[:id])
  end

  def player_params
    params.require(:player).permit(:nickname)
  end
end
