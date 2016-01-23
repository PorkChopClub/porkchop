class Api::ActivationsController < ApplicationController
  before_action :require_write_access, except: %i(index)

  def index
    @players = find_players
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

  def find_players
    Player.all.order(:name)
  end
end
