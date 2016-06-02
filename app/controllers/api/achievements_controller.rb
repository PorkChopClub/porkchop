class Api::AchievementsController < ApplicationController
  authorize_resource

  def index
    @achievements = Achievement.includes(:player)
  end
end
