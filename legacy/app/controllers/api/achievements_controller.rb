class Api::AchievementsController < ApplicationController
  def index
    authorize! :show, Achievement
    @achievements = Achievement.includes(:player)
  end
end
