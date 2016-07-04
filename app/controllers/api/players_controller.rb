class Api::PlayersController < ApplicationController
  def index
    @players = Player.all
    authorize! :read, @players
  end
end
