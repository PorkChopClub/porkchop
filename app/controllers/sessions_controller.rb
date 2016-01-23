class SessionsController < ApplicationController
  def authenticate
    if params[:password] == ENV['WRITE_ACCESS_PASSWORD']
      session[:write_access] = true
      render nothing: true, status: :ok
    else
      render nothing: true, status: :unauthorized
    end
  end
end
