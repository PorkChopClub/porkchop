class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  check_authorization unless: :skip_auth_check?

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, alert: exception.message
  end

  def skip_auth_check?
    false
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
