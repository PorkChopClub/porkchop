class SeasonsController < ApplicationController
  load_and_authorize_resource only: [:show]

  def show
  end
end
