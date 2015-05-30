class HomeController < ApplicationController
  skip_authorization_check only: [:index]

  def index
    @recent_matches = Match.finalized.order(finalized_at: :desc).limit(10)
    @ranked_players = Player.all.
                      select do |p|
                        p.matches.finalized.count >= 20 &&
                        p.last_played_at > 30.days.ago
                      end.
                      sort_by(&:elo).
                      reverse

    @elo_range = (30.days.ago.to_date..Date.current).to_a
    @elo_data = @ranked_players.map do |player|
      [
        player.name,
        @elo_range.map { |d| [d, player.elo_on(d)] }.to_h
      ]
    end.to_h
  end
end
