class HomeController < ApplicationController
  skip_authorization_check only: [:index]

  def index
    @recent_matches = Match.finalized.order(finalized_at: :desc).limit(10)
    @ranked_players = Player.all.
                      select do |p|
                        p.matches.finalized.count >= 20 &&
                        p.matches.finalized.where("finalized_at > ?", 14.days.ago).count > 4
                      end.
                      sort_by(&:elo).
                      reverse

    @elo_range = (30.days.ago.to_date..Date.current)

    @all_elo_ratings = EloRating.where(created_at: @elo_range).group_by do |rating|
      [rating.player_id, rating.created_at.to_date]
    end.map do |(player_id, date), ratings|
      rating = ratings.last
      [[player_id, date], rating.rating]
    end.to_h

    @elo_data = @ranked_players.map do |player|
      previous_rating = player.elo_on(@elo_range.first)
      [
        player.name,
        @elo_range.map do |d|
          rating = @all_elo_ratings[[player.id, d]]
          previous_rating = rating if rating
          [d, rating || previous_rating]
        end.to_h
      ]
    end.to_h
  end
end
