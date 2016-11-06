class ApplicationController < ActionController::Base
  check_authorization unless: :devise_controller?
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:nickname])
  end

  def ongoing_match
    @ongoing_match ||= Table.default.try!(:ongoing_match)
  end
  helper_method :ongoing_match

  def current_ability
    @current_ability ||=
      Ability.new(current_player)
  end
end
