class MatchFinalizationJob < ActiveJob::Base
  queue_as :default

  def perform match
    @match = match
    send_notification!
    adjust_elo!
    collect_achievements!
  end

  private
  attr_reader :match

  def send_notification!
    return unless ENV["SLACK_WEBHOOK_URL"]
    notifier.ping(
      "#{victor_name} defeated #{loser_name}",
      attachments: [{
        fields: [{title: home_player_name, value: match.home_score},
                 {title: away_player_name, value: match.away_score}]}]
    )
  end

  def adjust_elo!
    EloAdjustment.new(
      victor: match.victor,
      loser: match.loser
    ).adjust!
  end

  def collect_achievements!
    [match.home_player, match.away_player].each do |player|
      player.unearned_achievements.select(&:achieved?).each(&:save!)
    end
  end

  def victor_name
    match.victor.name
  end

  def loser_name
    match.loser.name
  end

  def home_player_name
    match.home_player.name
  end

  def away_player_name
    match.away_player.name
  end

  def notifier
    @notifier ||= Slack::Notifier.new(
      ENV["SLACK_WEBHOOK_URL"],
      username: "PorkChop",
      icon_emoji: ":trophy:"
    )
  end
end
