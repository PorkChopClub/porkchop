class OngoingMatchSerializer < MatchSerializer
  attributes :home_service_state,
             :away_service_state,
             :service_selected,
             :finished?,
             :seconds_old

  belongs_to :next_matchup

  def home_service_state
    if unstarted_or_finished?
      'no-service'
    elsif home_service?
      'serving'
    else
      'receiving'
    end
  end

  def away_service_state
    if unstarted_or_finished?
      'no-service'
    elsif home_service?
      'receiving'
    else
      'serving'
    end
  end

  def seconds_old
    Time.zone.now.to_i - object.created_at.to_i
  end

  def service_selected
    service_selected?
  end

  def next_matchup
    Matchmaker.choose
  end

  private

  def unstarted_or_finished?
    !service_selected? || object.finished?
  end

  def home_service?
    points_count = object.points.count
    object.first_service_by_away_player? ^ (points_count >= 20 ? points_count : points_count / 2).even?
  end

  def service_selected?
    !object.first_service.nil?
  end
end
