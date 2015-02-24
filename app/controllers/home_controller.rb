class HomeController < ApplicationController
  skip_authorization_check only: [:index]

  def index
    @recent_matches = Match.finalized.order(finalized_at: :desc).limit(10)
  end
end
