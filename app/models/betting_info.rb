class BettingInfo < ActiveRecord::Base
  belongs_to :match
  belongs_to :favourite, class_name: "Player"

  validates :match, presence: true

  before_create :compute_info

  private

  def compute_info
    spread = Betting::Spread.new(
      home_player: match.home_player,
      away_player: match.away_player
    )
    self.spread = spread.spread
    self.favourite = spread.favourite
  end
end
