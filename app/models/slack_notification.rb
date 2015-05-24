class SlackNotification
  def initialize(match)
    @match = match
  end

  def deliver
    return unless webhook_url
    notifier.ping title, attachments: attachments
  end

  private

  attr_reader :match

  def title
    "#{victor_name} defeated #{loser_name}"
  end

  def attachments
    [{
      fallback: "#{home_player_name} #{match.home_score} - #{match.away_score} #{away_player_name}",
      fields: [
        { title: home_player_name, value: match.home_score, short: true },
        { title: away_player_name, value: match.away_score, short: true }
      ]
    }]
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

  def webhook_url
    ENV["SLACK_WEBHOOK_URL"]
  end

  def notifier
    @notifier ||= Slack::Notifier.new(
      webhook_url,
      username: "PorkChop",
      icon_emoji: ":trophy:"
    )
  end
end
