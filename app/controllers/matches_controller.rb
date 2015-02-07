class MatchesController < ApplicationController
  before_action :check_for_ongoing_match, only: [:create, :new]

  def new
    @match = Match.new
  end

  def create
    @match = Match.new(match_params)
    if @match.save
      redirect_to scoreboard_show_path
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
      redirect_to scoreboard_show_path
    end
  end
end
