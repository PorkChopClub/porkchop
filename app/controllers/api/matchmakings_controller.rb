class Api::MatchmakingsController < ApplicationController
  skip_authorization_check
  skip_before_action :verify_authenticity_token

  def show
    render json: Matchmaker.new(Player.active).explain
  end
end
