json.achievements @achievements do |achievement|
  json.(achievement, :id, :variety, :rank, :updated_at, :created_at)

  json.(achievement, :display_name)

  json.player achievement.player
end
