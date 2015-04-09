class Api::ActivationsController < ApplicationController
  def index
    authorize! :read, Player
    @players = Player.all
  end

  def activate
    authorize! :read, Player
    authorize! :update, player

    player.active = true
    player.save

    @players = Player.all
    render :index
  end

  def deactivate
    authorize! :read, Player
    authorize! :update, player

    player.active = false
    player.save

    @players = Player.all
    render :index
  end

  private

  def player
    @player ||= Player.find_by_id(params[:id])
  end
end
