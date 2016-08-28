class Api::V2::MatchesController < ApplicationController
  before_filter :load_table

  def ongoing
    @match = @table.ongoing_match
    authorize! :read, @match
    if @match
      render json: @match, include: [:home_player, :away_player, :points]
    else
      render json: { data: nil }
    end
  end

  private

  def load_table
    @table = Table.find(params[:table_id])
  end
end
