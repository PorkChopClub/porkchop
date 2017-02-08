module Api
  module V2
    class ActivePlayersController < ApplicationController
      before_action :load_table
      before_action :load_player, only: [:create, :destroy]

      def index
        render json: @table.active_players
      end

      def create
        @player.update!(active: true)
        render json: @table.active_players
      end

      def destroy
        @player.update!(active: false)
        render json: @table.active_players
      end

      private

      def load_table
        @table = Table.find(params[:table_id])
        authorize! :read, @table
      rescue ActiveRecord::RecordNotFound
        render json: nil, status: :not_found
      end

      def load_player
        @player = Player.find(params[:id] || params[:active_player][:id])
        authorize! :update, @player
      rescue ActiveRecord::RecordNotFound
        render json: nil, status: :not_found
      end
    end
  end
end
