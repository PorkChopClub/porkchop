require_dependency "ping_pong/service"

class Api::OngoingMatchesController < ApplicationController
  before_action :authorize_ongoing_match, except: %i(show)
  before_action :set_next_match

  def show
    authorize! :read, ongoing_match
    head :not_found unless ongoing_match
  end

  def home_point
    perform record_service(ongoing_match.home_player)
  end

  def away_point
    perform record_service(ongoing_match.away_player)
  end

  def toggle_service
    perform ongoing_match.toggle_service
  end

  def rewind
    perform rewind_match
  end

  def finalize
    perform finalize_match
  end

  def destroy
    perform(ongoing_match.present? && ongoing_match.destroy)
  end

  def matchmake
    if ongoing_match.present?
      if !ongoing_match.destroy
        render :show, status: :unprocessable_entity
        return
      end
    end

    perform @ongoing_match = Match.setup!
  end

  private

  def authorize_ongoing_match
    authorize! :update, ongoing_match
  end

  def set_next_match
    @next_match = Matchmaker.choose
  end

  def finalize_match
    MatchFinalizationJob.perform_later(ongoing_match)
    true
  end

  def record_service(victor)
    PingPong::Service.new(match: ongoing_match, victor: victor).record!
  end

  def rewind_match
    PingPong::Rewind.new(ongoing_match).rewind!
  end

  def perform(action)
    if action
      render :show
    else
      render :show, status: :unprocessable_entity
    end
  end
end
