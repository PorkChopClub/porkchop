class HomeController < ApplicationController
  before_action :load_recent_matches
  before_action :load_ranked_players
  before_action :load_elo_data

  private

  def load_recent_matches
    @recent_matches = Match.finalized.order(finalized_at: :desc).limit(10)
    authorize! :read, :recent_matches
  end

  def load_ranked_players
    @ranked_players =
      Player.all.
      select do |p|
        p.matches.finalized.count >= 20 &&
        p.matches.finalized.where("finalized_at > ?", 14.days.ago).count > 4
      end.
      sort_by(&:elo).
      reverse
    authorize! :read, :ranked_players
  end

  def load_elo_data
    @elo_range = (30.days.ago.to_date..Date.current)

    @all_elo_ratings =
      EloRating.
      where("created_at > ?", 30.days.ago).
      order(:created_at).
      group_by { |rating| [rating.player_id, rating.created_at.to_date] }.
      map { |(player_id, date), ratings| [[player_id, date], ratings.last.rating] }.
      to_h

    @elo_data =
      @ranked_players.
      map do |player|
        previous_rating = player.elo_on(@elo_range.first)
        [
          player.name,
          @elo_range.map do |d|
            rating = @all_elo_ratings[[player.id, d]]
            previous_rating = rating if rating
            [d, rating || previous_rating]
          end.to_h
        ]
      end.
      to_h
  end
end
