class MatchesController < ApplicationController
  before_action :check_for_ongoing_match, only: %i(new create)
  before_action :require_write_access, only: %i(new create)

  def index
    @matches = Match.finalized.order(finalized_at: :desc)
  end

  def show
    @match = Match.find(params[:id])
  end

  private

  def check_for_ongoing_match
    if Match.ongoing.count != 0
      redirect_to edit_scoreboard_path
    end
  end
end
