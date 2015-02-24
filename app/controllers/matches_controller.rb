class MatchesController < ApplicationController
  before_action :check_for_ongoing_match, only: [:new, :create]
  load_and_authorize_resource

  def index
    @matches = @matches.order(finalized_at: :desc)
  end

  def new
    @players = Player.all.sort_by{ |p| p.matches.count }.reverse
  end

  def create
    if @match.save
      redirect_to edit_scoreboard_path
    else
      render :new
    end
  end

  private

  def match_params
    params.require(:match).permit :home_player_id, :away_player_id
  end

  def check_for_ongoing_match
    if Match.ongoing.count != 0
      redirect_to edit_scoreboard_path
    end
  end
end
