class Api::V2::MatchesController < ApplicationController
  before_action :load_table
  before_action :authorize_ongoing_match, only: :setup
  after_action :update_match_channel, except: :show

  def ongoing
    match = @table.ongoing_match
    authorize! :read, match
    render_match(match)
  end

  # FIXME: This action destroys the match on the specified table, but currently
  # makes a new one on the default table. Because being "active" is currently
  # not table specific, this is fine for now.
  def setup
    ongoing_match = @table.ongoing_match

    authorize! :destroy, ongoing_match
    if ongoing_match.present? && !ongoing_match.destroy
      render :show, status: :unprocessable_entity
      return
    end

    render_match(
      Match.setup!,
      success_status: :created,
      failure_status: :unprocessable_entity
    )
  end

  private

  def load_table
    @table = Table.find(params[:table_id])
    authorize! :read, @table
  rescue ActiveRecord::RecordNotFound
    render json: nil, status: :not_found
  end

  def authorize_ongoing_match
    authorize! :update, ongoing_match
  end

  def render_match(match, success_status: :ok, failure_status: :not_found)
    unless match
      render json: nil, status: failure_status
      return
    end

    render(
      json: match,
      serializer: OngoingMatchSerializer,
      include: [
        :home_player,
        :away_player,
        :next_matchup,
        :betting_info
      ],
      status: success_status
    )
  end
end
