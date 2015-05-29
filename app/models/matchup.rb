class Matchup
  include ActiveModel::Validations

  EPOCH = Time.at(0)

  validates :home_player, presence: true
  validates :away_player, presence: true
  validate :cant_play_agaist_yourself

  def self.all(players:)
    players.permutation(2).map do |(home_player, away_player)|
      new(home_player: home_player, away_player: away_player)
    end
  end

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
    match_history.last.try!(:created_at) || EPOCH
  end

  def match_history
    Match.
      where(home_player: home_player,
            away_player: away_player).
      order(created_at: :asc)
  end

  private

  def cant_play_agaist_yourself
    if home_player && home_player == away_player
      errors.add(:base, "One cannot play against oneself.")
    end
  end
end
