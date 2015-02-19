class HomeController < ApplicationController
  def index
    @recent_matches = Match.finalized.order(finalized_at: :desc).limit(10)
  end
end
