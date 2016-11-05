class ScoreboardsController < ApplicationController
  def show
    authorize! :read, Table.find(params[:id])
    @javascript_entrypoint = "scoreboard"
    @stylesheet = "scoreboard"
    @body_data = { "table-id": params[:id] }
    render layout: "minimal"
  end

  def edit
    authorize! :update, ongoing_match
  end
end
