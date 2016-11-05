class SlackNotification
  def initialize(match)
    @match = match
  end

  def deliver
    return unless webhook_url
    notifier.ping title
  end

  private

  attr_reader :match

  def title
    if match.home_player == match.victor
      "#{home_player_name} defeated #{away_player_name}, #{home_score} to #{away_score}"
    else
      "#{away_player_name} defeated #{home_player_name}, #{away_score} to #{home_score}"
    end
  end

  def home_player_name
    match.home_player.name
  end

  def away_player_name
    match.away_player.name
  end

  def home_score
    match.home_score
  end

  def away_score
    match.away_score
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
