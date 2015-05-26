class Matchup
  EPOCH = Time.at(0)

  def initialize(home_player:, away_player:)
    @home_player = home_player
    @away_player = away_player
  end

  attr_reader :home_player,
              :away_player

  def ==(other_object)
    if other_object.respond_to?(:home_player) &&
        other_object.respond_to?(:away_player)
      home_player == other_object.home_player &&
        away_player == other_object.away_player
    else
      super
    end
  end

  def last_played_at
    match_history.first.try!(:created_at) || EPOCH
  end

  def match_history
    Match.
      where(home_player: home_player,
            away_player: away_player).
      order(finalized_at: :asc)
  end
end
