class Stats::Personal
  def initialize(player)
    @player = player
  end

  def win_ratio
    if match_count != 0
      calculate_ratio(victory_count, match_count)
    else
      ".000"
    end
  end

  def win_ratio_by_opponent
    Hash[
      opponents.map do |opponent|
        [opponent, win_ratio_against(opponent)]
      end.
      sort_by{ |_k, v| v }.reverse
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

  def longest_winning_streak
    @player.streaks.where(streak_type: "W").maximum(:streak_length)
  end

  def longest_losing_streak
    @player.streaks.where(streak_type: "L").maximum(:streak_length)
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
    calculate_ratio(victory_count_against(opponent), match_count_against(opponent))
  end

  def calculate_ratio(wins, losses)
    ratio = (wins.to_f / losses.to_f)
    ("%.3f" % ratio).sub(/\A0/, "")
  end

  def victory_count_against(opponent)
    victories_by_player_id[opponent.id]
  end

  def match_count_against(opponent)
    loss_count_against(opponent) + victory_count_against(opponent)
  end

  def loss_count_against(opponent)
    losses_by_player_id[opponent.id]
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

  def victories_by_player_id
    @victories_by_player_id ||= Hash.new(0).update victories.group(Match::LOSER_SQL).count
  end

  def losses_by_player_id
    @losses_by_player_id ||= Hash.new(0).update losses.group(Match::WINNER_SQL).count
  end
end
