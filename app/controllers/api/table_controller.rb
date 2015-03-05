class Api::TableController < ApplicationController
  skip_authorization_check
  skip_before_action :verify_authenticity_token

  before_action :check_table_token
  before_action :match

  def home_button
    record_service match.home_player
    head :ok
  end

  def away_button
    record_service match.away_player
    head :ok
  end

  def center_button
    rewind_match
    head :ok
  end

  private

  def check_table_token
    unless params[:table_token] == ENV['TABLE_TOKEN']
      head :forbidden
    end
  end

  # FIXME: Copied out of Api::OngoingMatchController
  def record_service victor
    PingPong::Service.new(match: match, victor: victor).record!
  end

  # FIXME: Copied out of Api::OngoingMatchController
  def rewind_match
    PingPong::Rewind.new(match).rewind!
  end

  # FIXME: Copied out of Api::OngoingMatchController
  def match
    @match ||= PingPong::Match.new ongoing_match
  end
end
