class PingPong::TableControls
  def initialize(match)
    @match = match
  end

  def home_button
    player_button match.home_player
  end

  def away_button
    player_button match.away_player
  end

  def center_button
    rewind_match
  end

  private

  attr_reader :match

  def player_button(player)
    if match.finished?
      finalize_match
    else
      record_service player
    end
  end

  def record_service(victor)
    PingPong::Service.new(match: match, victor: victor).record!
  end

  def rewind_match
    PingPong::Rewind.new(match).rewind!
  end

  def finalize_match
    MatchFinalizationJob.perform_later match
  end
end
