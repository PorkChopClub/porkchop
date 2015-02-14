json.match do
  json.home_score @match.home_points.count
  json.away_score @match.away_points.count
  json.home_player_name @match.home_player.try(:name)
  json.away_player_name @match.away_player.try(:name)
  json.finished @match.finished?
  json.finalized @match.finalized?
end
