class PlayersController < ApplicationController
  load_and_authorize_resource

  def index
    @players = @players.order(:name)
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

  def player_params
    params.require(:player).permit(:name,
                                   :nickname,
                                   :avatar_url)
  end
end
