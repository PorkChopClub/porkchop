class Api::ActivationsController < ApplicationController
  def index
    authorize! :read, Player
    @players = find_players
  end

  def activate
    authorize! :read, Player
    authorize! :update, player

    player.active = true
    player.save

    @players = find_players
    render :index
  end

  def deactivate
    authorize! :read, Player
    authorize! :update, player

    player.active = false
    player.save

    @players = find_players
    render :index
  end

  private

  def player
    @player ||= Player.find_by_id(params[:id])
  end

  def find_players
    Player.all.order(:name)
  end
end
