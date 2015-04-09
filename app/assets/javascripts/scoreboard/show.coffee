#= require match_stream
#= require achievement_stream

$ ->
  return unless $('.scoreboard').length

  achievements = AchievementStream.polling(500).buffered(2000)
  match = MatchStream.polling(300)

  formatMessage = (achievement) ->
    if achievement
      "#{achievement.player.name} has earned the achievement #{achievement.display_name}"

  achievementMessages = achievements
    .map(formatMessage)
    .toProperty("")

  #############
  # Rendering #
  #############

  match.commentPresent
    .assign($(".scoreboard-message-area"), "toggleClass", "message-present")
  achievementMessages.or(match.comment)
    .assign($(".scoreboard-message"), "text")

  match.instructions
    .assign($(".scoreboard-instructions"), "text")

  match.awayPlayerService
    .assign($(".scoreboard-away-player"), "toggleClass", "has-service")
  match.homePlayerService
    .assign($(".scoreboard-home-player"), "toggleClass", "has-service")

  match.homeScore
    .assign $(".scoreboard-home-player-score"), "text"
  match.awayScore
    .assign $(".scoreboard-away-player-score"), "text"

  match.homePlayerDisplayName
    .assign $(".scoreboard-home-player-name"), "text"
  match.awayPlayerDisplayName
    .assign $(".scoreboard-away-player-name"), "text"

  backgroundmap = (url) -> if url? then "url(#{url})" else "none"
  match.homePlayerAvatarUrl
    .map backgroundmap
    .assign $(".scoreboard-home-player-avatar"), "css", "background-image"
  match.awayPlayerAvatarUrl
    .map backgroundmap
    .assign $(".scoreboard-away-player-avatar"), "css", "background-image"
