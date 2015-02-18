class Stats::Personal
  def initialize player
    @player = player
  end

  def win_ratio
    if player.matches.count != 0
      (player.victories.count/player.matches.count.to_f).round 3
    else
      0.0
    end
  end

  def record
    [player.victories.count, player.losses.count]
  end

  private
  attr_reader :player
end
