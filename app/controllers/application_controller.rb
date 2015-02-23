class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def ongoing_match
    @ongoing_match ||= Match.ongoing.first
  end
  helper_method :ongoing_match
end
