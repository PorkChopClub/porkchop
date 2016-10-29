class Api::V2::MatchesController < ApplicationController
  before_action :load_table

  def ongoing
    @match = @table.ongoing_match
    authorize! :read, @match
    if @match
      render json: @match, include: [:home_player, :away_player]
    else
      render json: { data: nil }
    end
  end

  private

  def load_table
    @table = Table.find(params[:table_id])
  rescue ActiveRecord::RecordNotFound
    render json: { data: nil }, status: :not_found
  end
end
