class MatchFinalizationJob < ApplicationJob
  queue_as :default

  def perform(match)
    @match = match

    return if match.finalized?
    return unless match.finished?

    match.victor = match.leader
    match.finalize!
    update_streaks!
    adjust_elo!
    matchmake!
    send_notification!
    update_match_channel
  end

  private

  attr_reader :match

  def send_notification!
    SlackGameEndJob.perform_later(match)
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

  def update_match_channel
    OngoingMatchChannel.broadcast_update
  end
end
