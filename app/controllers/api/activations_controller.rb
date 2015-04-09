class Api::ActivationsController < ApplicationController
  def index
    authorize! :read, Player
    @players = Player.all
  end
end
