class SlackGameEndJob < ApplicationJob
  queue_as :default

  def perform(match)
    @match = match
    SlackMessage.new(message).send!
  end

  private

  attr_reader :match

  def message
    if match.home_player == match.victor
      ":trophy: #{home_player_name} defeated #{away_player_name}, #{home_score} to #{away_score} :trophy:"
    else
      ":trophy: #{away_player_name} defeated #{home_player_name}, #{away_score} to #{home_score} :trophy:"
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
end
