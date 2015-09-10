class ChopNotifier
  def self.notify!
    new(Match.ongoing.first).notify!
  end

  def initialize(match)
    @match = match && PingPong::Match.new(match)
  end

  def notify!
    return unless ENV['CHOP_HOST']

    Faraday.new("http://#{ENV['CHOP_HOST']}") do |faraday|
      faraday.adapter  Faraday.default_adapter
    end.post do |req|
      req.url '/api/ongoing_match'
      req.headers['Content-Type'] = 'application/json'
      req.body = payload
    end
  end

  private

  attr_reader :match

  def payload
    if match
      match.to_builder.target!
    else
      "{}"
    end
  end
end
