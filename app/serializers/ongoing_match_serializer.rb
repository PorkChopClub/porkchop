class OngoingMatchSerializer < MatchSerializer
  attributes :home_service,
             :away_service,
             :service_selected,
             :finished?,
             :seconds_old

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

  def seconds_old
    Time.zone.now.to_i - object.created_at.to_i
  end
end
