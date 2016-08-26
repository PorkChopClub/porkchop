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
    @ranked_players = Player.ranked
    authorize! :read, :ranked_players
  end

  def load_elo_data
    @elo_range = (30.days.ago.to_date..Date.current)

    @all_elo_ratings =
      EloRating.
      where("created_at > ?", 30.days.ago).
      order(:created_at).
      pluck(:player_id, :created_at, :rating).
      group_by { |player_id, created_at, _rating| [player_id, created_at.to_date] }.
      map { |(player_id, date), ratings| [[player_id, date], ratings.last[2]] }.
      to_h

    @elo_data =
      @ranked_players.
      map do |player|
        previous_rating = @all_elo_ratings[[player.id, @elo_range.begin]]
        previous_rating ||= player.elo_on(@elo_range.first)
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
