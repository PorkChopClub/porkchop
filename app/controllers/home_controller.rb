class HomeController < ApplicationController
  def index
    authorize! :read, :home
  end

  private

  def recent_matches
    authorize! :read, :recent_matches
    @recent_matches ||= Match.finalized.order(finalized_at: :desc).limit(10)
  end
  helper_method :recent_matches

  def ranked_players
    authorize! :read, :ranked_players
    @ranked_players ||= Player.ranked
  end
  helper_method :ranked_players

  def elo_range
    @elo_range ||= (30.days.ago.to_date..Date.current)
  end

  def elo_data
    @all_elo_ratings ||=
      EloRating.
      where("created_at > ?", 30.days.ago).
      order(:created_at).
      pluck(:player_id, :created_at, :rating).
      group_by { |player_id, created_at, _rating| [player_id, created_at.to_date] }.
      map { |(player_id, date), ratings| [[player_id, date], ratings.last[2]] }.
      to_h

    @elo_data ||=
      @ranked_players.
      map do |player|
        previous_rating = @all_elo_ratings[[player.id, elo_range.begin]]
        previous_rating ||= player.elo_on(elo_range.first)
        [
          player.name,
          elo_range.map do |d|
            rating = @all_elo_ratings[[player.id, d]]
            previous_rating = rating if rating
            [d, rating || previous_rating]
          end.to_h
        ]
      end.
      to_h
  end

  helper_method :elo_data
  helper_method :elo_range
end
