module Api
  module V2
    class ActivePlayersController < ApplicationController
      before_action :load_table

      def index
        render json: @table.active_players
      end

      private

      def load_table
        @table = Table.find(params[:table_id])
        authorize! :read, @table
      rescue ActiveRecord::RecordNotFound
        render json: nil, status: :not_found
      end
    end
  end
end
