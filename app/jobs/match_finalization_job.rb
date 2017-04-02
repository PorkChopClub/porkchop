class MatchFinalizationJob < ApplicationJob
  queue_as :default

  def perform(match)
    @match = match

    return if match.finalized?
    return unless match.finished?

    Match.transaction do
      match.victor = match.leader
      match.finalize!

      award_complete_match_experience
      award_won_match_experience

      update_streaks!

      adjust_elo!
    end

    send_notification!
    update_match_channel
    matchmake!
  end

  private

  attr_reader :match

  def award_complete_match_experience
    [match.home_player, match.away_player].each do |player|
      player.experiences.create!(
        match: match,
        reason: :completed_match
      )
    end
  end

  def award_won_match_experience
    match.victor.experiences.create!(
      match: match,
      reason: :won_match
    )
  end

  def send_notification!
    SlackGameEndJob.perform_later(match)
  end

  def adjust_elo!
    EloAdjustment.new(
      victor: match.victor,
      loser: match.loser,
      match: match
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
