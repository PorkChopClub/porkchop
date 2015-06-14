class Stats::Personal
  def initialize(player)
    @player = player
  end

  def win_ratio
    if match_count != 0
      (victory_count / match_count.to_f).round 3
    else
      0.0
    end
  end

  def win_ratio_by_opponent
    Hash[
      opponents.map do |opponent|
        [opponent.name, win_ratio_against(opponent)]
      end
    ]
  end

  def record_against(opponent)
    [victory_count_against(opponent), loss_count_against(opponent)]
  end

  def record
    [victory_count, loss_count]
  end

  def last_10_results
    [last_10_victory_count, last_10_loss_count]
  end

  def highest_elo_rating
    @player.elo_ratings.maximum(:rating)
  end

  def lowest_elo_rating
    @player.elo_ratings.minimum(:rating)
  end

  private

  attr_reader :player
  delegate :matches,
           :losses,
           :victories,
           :opponents,
           :matches_against,
           to: :player

  def win_ratio_against(opponent)
    (victory_count_against(opponent) / match_count_against(opponent).to_f).round 3
  end

  def victory_count_against(opponent)
    matches_against(opponent).where(victor: player).count
  end

  def match_count_against(opponent)
    matches_against(opponent).count
  end

  def loss_count_against(opponent)
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

  def last_10_matches
    @last_10_matches ||= matches.finalized.last(10)
  end

  def last_10_victory_count
    last_10_matches.select { |m| m.victor == player }.size
  end

  def last_10_loss_count
    last_10_matches.select { |m| m.victor != player }.size
  end
end
