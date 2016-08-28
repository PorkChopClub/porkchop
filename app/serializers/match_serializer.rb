class MatchSerializer < ActiveModel::Serializer
  attributes :id,
             :home_score,
             :away_score,
             :home_service,
             :away_service,
             :service_selected

  belongs_to :home_player
  belongs_to :away_player

  has_many :points

  def home_service
    return unless object.first_service? || object.finished?
    points_count = object.points.count
    object.first_service_by_away_player? ^ (points_count >= 20 ? points_count : points_count / 2).even?
  end

  def away_service
    return unless object.first_service? || object.finished?
    !home_service
  end

  def service_selected
    !object.first_service.nil?
  end
end
