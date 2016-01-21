class Api::OngoingMatchesController < ApplicationController
  before_action :match

  before_action :require_write_access, except: %i(show)
  before_action :set_next_match

  def show
    if !match
      head :not_found
    end
  end

  def home_point
    perform record_service(match.home_player)
  end

  def away_point
    perform record_service(match.away_player)
  end

  def toggle_service
    perform match.toggle_service
  end

  def rewind
    perform rewind_match
  end

  def finalize
    perform finalize_match
  end

  def destroy
    perform match.try! :destroy
  end

  def matchmake
    if match.present?
      if !match.destroy
        render :show, status: :unprocessable_entity
        return
      end
    end

    perform @match = PingPong::Match.new(Match.setup!)
  end

  private

  def set_next_match
    @next_match = Matchmaker.choose
  end

  def match
    @match ||= PingPong::Match.new ongoing_match
  end

  def authorize_update
    authorize! :update, @match || Match
  end

  def finalize_match
    PingPong::Finalization.new(match).finalize!
  end

  def record_service(victor)
    PingPong::Service.new(match: match, victor: victor).record!
  end

  def rewind_match
    PingPong::Rewind.new(match).rewind!
  end

  def perform(action)
    if action
      ChopNotifier.notify!
      render :show
    else
      render :show, status: :unprocessable_entity
    end
  end
end
