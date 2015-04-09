class ActivationsController < ApplicationController
  def edit
    authorize! :update, Player
  end
end
