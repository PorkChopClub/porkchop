class MatchFinalizationJob < ActiveJob::Base
  queue_as :default

  def perform(match)
    @match = match
    send_notification!
    adjust_elo!
    update_streaks!
    matchmake!
  end

  private

  attr_reader :match

  def send_notification!
    SlackNotification.new(match).deliver
  end

  def adjust_elo!
    EloAdjustment.new(
      victor: match.victor,
      loser: match.loser,
      matches: match.all_matches_before
    ).adjust!
  end

  def update_streaks!
    Stats::StreakAdjustment.new(player: match.victor, match_result: "W").adjust!
    Stats::StreakAdjustment.new(player: match.loser, match_result: "L").adjust!
  end

  def matchmake!
    Match.setup!
  end
end
