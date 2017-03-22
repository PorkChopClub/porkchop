class HomeController < ApplicationController
  def index
    authorize! :read, :home
  end
end
