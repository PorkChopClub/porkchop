class HomeController < ApplicationController
  skip_authorization_check only: [:index]

  def index
    @recent_matches = Match.finalized.order(finalized_at: :desc).limit(10)
    @ranked_players = Player.all.
                      select { |p| p.matches.finalized.count >= 20 }.
                      sort_by(&:elo).
                      reverse
  end
end
