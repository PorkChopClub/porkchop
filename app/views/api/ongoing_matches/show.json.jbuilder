json.match do
  json.id @ongoing_match.to_param

  json.home_score @ongoing_match.home_score
  json.home_player_name @ongoing_match.home_player.try!(:nickname) || @ongoing_match.home_player.try!(:name)
  json.home_player_avatar_url @ongoing_match.home_player.avatar_url unless @ongoing_match.home_player.avatar_url.blank?
  json.home_player_overlays do
    json.flames begin
      points = @ongoing_match.points.order(created_at: :desc)
      points.first.try!(:victor) == @ongoing_match.home_player &&
      points.chunk(&:victor).to_a[0][1].size > 4
    end
  end

  json.away_score @ongoing_match.away_score
  json.away_player_name @ongoing_match.away_player.try!(:nickname) || @ongoing_match.away_player.try!(:name)
  json.away_player_avatar_url @ongoing_match.away_player.avatar_url unless @ongoing_match.away_player.avatar_url.blank?
  json.away_player_overlays do
    json.flames begin
      points = @ongoing_match.points.order(created_at: :desc)
      points.first.try!(:victor) == @ongoing_match.away_player &&
      points.chunk(&:victor).to_a[0][1].size > 4
    end
  end

  json.home_player_service !!@ongoing_match.home_player_service?
  json.away_player_service !!@ongoing_match.away_player_service?
  json.finished @ongoing_match.finished?
  json.finalized @ongoing_match.finalized?
  json.deleted @ongoing_match.destroyed?
  json.league_match @ongoing_match.league_match?

  json.warmup @ongoing_match.warmup?
  json.warmup_timer @ongoing_match.warmup_seconds_left

  json.betting_info do
    if @ongoing_match.betting_info
      json.favourite @ongoing_match.betting_info.favourite.try!(:name)
      json.spread @ongoing_match.betting_info.spread
    end
  end
end

json.next_match do
  json.players @next_match.players, :name, :nickname, :avatar_url
end
