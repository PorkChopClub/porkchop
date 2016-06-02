class SeasonsController < ApplicationController
  def show
    @season = Season.find(params[:id])
    authorize! :read, @season
  end
end
