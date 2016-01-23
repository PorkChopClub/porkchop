class ScoreboardsController < ApplicationController
  before_action :require_write_access, except: %i(show)

  def show
    @javascript_entrypoint = "scoreboard"
    render layout: "minimal"
  end

  def edit
  end
end
