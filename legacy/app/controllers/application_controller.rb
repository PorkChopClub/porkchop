class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def require_write_access
    return if session[:write_access]
    redirect_to root_url, alert: "Please login first."
  end

  def ongoing_match
    @ongoing_match ||= Match.ongoing.first
  end
  helper_method :ongoing_match

  def current_user
    @current_user ||= User.find_by_id session[:user_id]
  end
  helper_method :current_user
end
