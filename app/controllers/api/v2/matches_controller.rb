class Api::V2::MatchesController < ApplicationController
  before_filter :load_table

  def ongoing
    @match = @table.ongoing_match
    authorize! :read, @match
    render json: @match
  end

  private

  def load_table
    @table = Table.find(params[:table_id])
  end
end
