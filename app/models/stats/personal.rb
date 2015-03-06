class Stats::Personal
  def initialize player
    @player = player
  end

  def win_ratio
    if match_count != 0
      (victory_count/match_count.to_f).round 3
    else
      0.0
    end
  end

  def win_ratio_by_opponent
    opponents.inject({}) do |acc, opponent|
      acc[opponent.name] = win_ratio_against(opponent)
      acc
    end
  end

  def record_against opponent
    [victory_count_against(opponent), loss_count_against(opponent)]
  end

  def record
    [victory_count, loss_count]
  end

  private
  attr_reader :player
  delegate :matches,
           :losses,
           :victories,
           :opponents,
           :matches_against,
           to: :player

  def win_ratio_against opponent
    (victory_count_against(opponent)/match_count_against(opponent).to_f).round 3
  end

  def victory_count_against opponent
    matches_against(opponent).where(victor: player).count
  end

  def match_count_against opponent
    matches_against(opponent).count
  end

  def loss_count_against opponent
    match_count_against(opponent) - victory_count_against(opponent)
  end

  def victory_count
    victories.count
  end

  def loss_count
    losses.count
  end

  def match_count
    matches.finalized.count
  end
end
