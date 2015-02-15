class Api::OngoingMatchesController < ApplicationController
  before_action :load_ongoing_match

  def show
    unless @match
      head :not_found
    end
  end

  def home_point
    if record_service @match.home_player
      render :show
    else
      render :show, status: :unprocessable_entity
    end
  end

  def away_point
    if record_service @match.away_player
      render :show
    else
      render :show, status: :unprocessable_entity
    end
  end

  def rewind
    if rewind_match
      render :show
    else
      render :show, status: :unprocessable_entity
    end
  end

  def finalize
    if finalize_match
      render :show
    else
      render :show, status: :unprocessable_entity
    end
  end

  def destroy
    if @match
      @match.destroy
      render :show
    else
      render :show, status: :unprocessable_entity
    end
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
end
