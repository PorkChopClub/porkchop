class Api::OngoingMatchesController < ApplicationController
  before_action :load_ongoing_match

  def show
    unless @match
      head :not_found
    end
  end

  def home_point
    perform record_service(@match.home_player)
  end

  def away_point
    perform record_service(@match.away_player)
  end

  def toggle_service
    perform @match.toggle!(:first_service_by_home_player)
  end

  def rewind
    perform rewind_match
  end

  def finalize
    perform finalize_match
  end

  def destroy
    perform @match && @match.destroy
  end

  private

  def finalize_match
    PingPong::Finalization.new(@match).finalize!
  end

  def record_service victor
    PingPong::Service.new(
      match: @match,
      victor: victor
    ).record!
  end

  def rewind_match
    PingPong::Rewind.new(@match).rewind!
  end

  def load_ongoing_match
    @match = ongoing_match
  end

  def perform(action)
    if action
      render :show
    else
      render :show, status: :unprocessable_entity
    end
  end
end
