$ ->
  return unless $('.scoreboard').length

  achievements = PorkChop.AchievementStream.polling(500).buffered(10000)
  match = PorkChop.MatchStream.polling(300)

  formatMessage = (achievement) ->
    if achievement
      "#{achievement.player.name} has earned the achievement #{achievement.display_name}"

  achievementMessages = achievements
    .map(formatMessage)
    .toProperty("")

  message = achievementMessages.or(match.comment)

  #############
  # Rendering #
  #############

  message
    .assign($(".scoreboard-message"), "text")

  message
    .map (message) -> !!message
    .assign($(".scoreboard-message-area"), "toggleClass", "message-present")

  match.instructions
    .assign($(".scoreboard-instructions"), "text")

  match.league_match
    .assign($(".scoreboard-message-area"), "toggleClass", "league-match")

  match.league_match
    .assign($(".scoreboard-league-match"), "toggle")

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
