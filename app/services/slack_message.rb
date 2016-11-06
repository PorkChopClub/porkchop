class SlackMessage
  def initialize(*args)
    @args = args
  end

  def send!
    return unless webhook_url
    notifier.public_send(:ping, *args)
  end

  private

  attr_reader :args

  def webhook_url
    ENV["SLACK_WEBHOOK_URL"]
  end

  def notifier
    @notifier ||= Slack::Notifier.new(
      webhook_url,
      username: "PorkChop",
      icon_emoji: ":porkchop:"
    )
  end
end
