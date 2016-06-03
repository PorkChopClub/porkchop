class Api::ActivationsController < ApplicationController
  before_action :authorize_write_player, only: %i(activate deactivate)

  def index
    @players = find_players
    authorize! :read, @players
  end

  def activate
    player.active = true
    player.save

    @players = find_players
    render :index
  end

  def deactivate
    player.active = false
    player.save

    @players = find_players
    render :index
  end

  private

  def player
    @player ||= Player.find_by_id(params[:id])
  end

  def authorize_write_player
    authorize! :update, player
  end

  def find_players
    Player.all.order(:name)
  end
end
