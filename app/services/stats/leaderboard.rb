module Stats
  class Leaderboard
    Row = Struct.new(
      :rank,
      :player,
      :elo,
      :elo_change_day,
      :elo_change_week,
      :last_10_wins,
      :last_10_losses,
      :streak_type,
      :streak_length
    )

    LAST_10_SQL = <<-SQL.freeze
      (SELECT victor_id FROM "matches" WHERE ("players"."id" IN (home_player_id, away_player_id)) AND finalized_at IS NOT NULL ORDER BY finalized_at DESC LIMIT 10) AS last_10
    SQL
    STREAK_SQL = <<-SQL.freeze
      "streaks" WHERE player_id = "players"."id" AND "streaks"."finished_at" IS NULL
    SQL

    def rows
      day_ago = Date.yesterday.end_of_day
      week_ago = Date.yesterday.beginning_of_week(:sunday).end_of_day
      players = Player.ranked.select <<-SQL
        "players".*,
        (SELECT rating FROM "elo_ratings" WHERE player_id = "players"."id" ORDER BY created_at DESC LIMIT 1) AS elo,
        (SELECT rating FROM "elo_ratings" WHERE player_id = "players"."id" AND created_at <= '#{day_ago.to_s(:db)}' ORDER BY created_at DESC LIMIT 1) AS elo_day_ago,
        (SELECT rating FROM "elo_ratings" WHERE player_id = "players"."id" AND created_at <= '#{week_ago.to_s(:db)}' ORDER BY created_at DESC LIMIT 1) AS elo_week_ago,
        (SELECT SUM(CASE WHEN victor_id = "players"."id" THEN 1 ELSE 0 END) FROM #{LAST_10_SQL}) AS last_10_wins,
        (SELECT SUM(CASE WHEN victor_id = "players"."id" THEN 0 ELSE 1 END) FROM #{LAST_10_SQL}) AS last_10_losses,
        (SELECT streak_type   FROM #{STREAK_SQL}),
        (SELECT streak_length FROM #{STREAK_SQL})
      SQL
      players.map.with_index do |player, i|
        Row.new(
          i + 1,
          player,
          player[:elo] || Player::BASE_ELO,
          (player[:elo_day_ago] || Player::BASE_ELO) - player[:elo],
          (player[:elo_week_ago] || Player::BASE_ELO) - player[:elo],
          player[:last_10_wins],
          player[:last_10_losses],
          player[:streak_type],
          player[:streak_length]
        )
      end
    end
  end
end
