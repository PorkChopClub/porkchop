class SessionsController < ApplicationController
  skip_authorization_check

  def create
    user = User.from_omniauth omniauth
    session[:user_id] = user.id

    redirect_to root_url
  end

  def destroy
    session.delete(:user_id)

    redirect_to root_url
  end

  private

  def omniauth
    request.env["omniauth.auth"]
  end
end
