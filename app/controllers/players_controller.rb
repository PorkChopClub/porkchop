class PlayersController < ApplicationController
  before_filter :load_player, except: :index

  def index
    @players = Player.order(:name)
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
    params.require(:player).permit(:name, :avatar_url)
  end
end
