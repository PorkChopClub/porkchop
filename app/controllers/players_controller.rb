class PlayersController < ApplicationController
  def show
    @player = Player.find(params[:id])
    @stats = Stats::Personal.new(@player)
  end
end
