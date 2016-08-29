json.match do
  json.id @match.to_param

  json.home_score @match.home_score
  json.home_player_name @match.home_player.try!(:nickname) || @match.home_player.try!(:name)
  json.home_player_avatar_url @match.home_player.avatar_url unless @match.home_player.avatar_url.blank?
  json.home_player_overlays do
    json.flames begin
      points = @match.points.order(created_at: :desc)
      points.first.try!(:victor) == @match.home_player &&
      points.chunk(&:victor).to_a[0][1].size > 4
    end
  end

  json.away_score @match.away_score
  json.away_player_name @match.away_player.try!(:nickname) || @match.away_player.try!(:name)
  json.away_player_avatar_url @match.away_player.avatar_url unless @match.away_player.avatar_url.blank?
  json.away_player_overlays do
    json.flames begin
      points = @match.points.order(created_at: :desc)
      points.first.try!(:victor) == @match.away_player &&
      points.chunk(&:victor).to_a[0][1].size > 4
    end
  end

  json.home_player_service !!@match.home_player_service?
  json.away_player_service !!@match.away_player_service?
  json.finished @match.finished?
  json.finalized @match.finalized?
  json.deleted @match.destroyed?
  json.league_match @match.league_match?
  json.comment @match.comment || ""
  json.instructions @match.instructions || ""

  json.warmup @match.warmup?
  json.warmup_timer @match.warmup_seconds_left

  json.betting_info do
    if @match.betting_info
      json.favourite @match.betting_info.favourite.try!(:name)
      json.spread @match.betting_info.spread
    end
  end
end

json.next_match do
  json.players @next_match.players, :name, :nickname, :avatar_url
end
