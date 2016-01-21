class Api::AchievementsController < ApplicationController
  def index
    @achievements = Achievement.includes(:player)
  end
end
