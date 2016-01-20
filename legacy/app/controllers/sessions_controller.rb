class SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token
  skip_authorization_check

  def authenticate
    if params[:password] == ENV['WRITE_ACCESS_PASSWORD']
      session[:write_access] = true
      render nothing: true, status: :ok
    else
      render nothing: true, status: :unauthorized
    end
  end
end
