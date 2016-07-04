class ScoreboardsController < ApplicationController
  def show
    authorize! :read, ongoing_match
    @javascript_entrypoint = "scoreboard"
    render layout: "minimal"
  end

  def edit
    authorize! :update, ongoing_match
  end
end
