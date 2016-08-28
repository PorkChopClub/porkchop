class ScoreboardsController < ApplicationController
  def show
    if (table_id = params[:id])
      authorize! :read, Table.find(table_id)
      @javascript_entrypoint = "scoreboard"
      @stylesheet = "scoreboard"
      @body_data = { "table-id": params[:id] }
      render layout: "minimal"
    else
      authorize! :read, ongoing_match.try!(:table)
      @javascript_entrypoint = "legacy_scoreboard"
      render :legacy_show, layout: "minimal"
    end
  end

  def edit
    authorize! :update, ongoing_match
  end
end
