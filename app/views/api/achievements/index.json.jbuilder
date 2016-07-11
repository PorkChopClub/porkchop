json.achievements @achievements do |achievement|
  json.call(achievement, :id, :variety, :rank, :updated_at, :created_at)

  json.call(achievement, :display_name)

  json.player achievement.player
end
