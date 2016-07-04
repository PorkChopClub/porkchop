class MatchesController < ApplicationController
  load_and_authorize_resource

  def index
    @matches = @matches.finalized.order(finalized_at: :desc)
  end
end
