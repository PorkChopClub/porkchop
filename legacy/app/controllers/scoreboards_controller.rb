class ScoreboardsController < ApplicationController
  skip_authorization_check only: [:show, :edit]

  def show
    render layout: "minimal"
  end

  def edit
    authorize! :edit, ongoing_match
  end
end
