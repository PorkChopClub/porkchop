class ApplicationController < ActionController::Base
  check_authorization
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end

  def require_write_access
    return if session[:write_access]
    redirect_to root_url, alert: "Please login first."
  end

  def ongoing_match
    @ongoing_match ||= Match.ongoing.first
  end
  helper_method :ongoing_match

  def write_access?
    session[:write_access]
  end
  helper_method :write_access?
end
