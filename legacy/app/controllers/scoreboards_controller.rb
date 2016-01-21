class ScoreboardsController < ApplicationController
  before_action :require_write_access, except: %i(show)

  def show
    render layout: "minimal"
  end

  def edit
  end
end
