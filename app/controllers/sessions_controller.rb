class SessionsController < ApplicationController
  def authenticate
    if params[:password] == ENV['WRITE_ACCESS_PASSWORD']
      session[:write_access] = true
      flash[:notice] = "Access granted."
    else
      flash[:error] = "Access denied."
    end

    redirect_back fallback_location: root_url
  end
end
