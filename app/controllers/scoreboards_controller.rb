class ScoreboardsController < ApplicationController
  def show
    authorize! :read, Table.find(params[:id])
    authorize! :update, ongoing_match
    @javascript_entrypoint = "scoreboard"
    @stylesheet = "scoreboard"
    @body_data = { "table-id": params[:id] }
    render layout: "minimal"
  end
end
