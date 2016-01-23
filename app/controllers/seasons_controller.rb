class SeasonsController < ApplicationController
  def show
    @season = Season.find(params[:id])
  end
end
