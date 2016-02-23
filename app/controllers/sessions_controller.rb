class SessionsController < ApplicationController
  def authenticate
    if params[:password] == ENV['WRITE_ACCESS_PASSWORD']
      session[:write_access] = true
      redirect_to :back, flash: { notice: "Access granted." }
    else
      redirect_to :back, flash: { error: "Access denied." }
    end
  end
end
