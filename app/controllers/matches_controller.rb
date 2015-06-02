class MatchesController < ApplicationController
  before_action :check_for_ongoing_match, only: [:new, :create]
  load_and_authorize_resource only: [:index, :show, :create]
  skip_authorization_check only: [:new]

  def index
    @matches = @matches.finalized.order(finalized_at: :desc)
  end

  private

  def check_for_ongoing_match
    if Match.ongoing.count != 0
      redirect_to edit_scoreboard_path
    end
  end
end
