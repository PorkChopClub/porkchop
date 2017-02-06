module Api
  module V2
    class Api::V2::PlayersController < ApplicationController
      def index
        players = Player.all
        authorize! :read, players
        render json: players
      end
    end
  end
end
