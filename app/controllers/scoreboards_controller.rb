class ScoreboardsController < ApplicationController
  skip_authorization_check only: [:show, :edit]

  def show
    render layout: "minimal"
  end

  def edit
    if ongoing_match
      authorize! :edit, ongoing_match
    else
      redirect_to new_match_url
    end
  end
end
