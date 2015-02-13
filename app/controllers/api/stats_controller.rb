class Api::StatsController < ApplicationController
  def points
    @points = Player.all.to_a.
      find_all { |p| p.points.any? }.
      sort_by { |p| -p.points.count }.
      map { |p| [p.name, p.points.count] }
  end
end
