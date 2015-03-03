$ ->
  return unless $('.scoreboard').length

  ajaxOptions = { url: '/api/ongoing_match.json' }
  matchPolls = Bacon.mergeAll([Bacon.interval(1000, ajaxOptions),
                               Bacon.once(ajaxOptions)]).ajax()

  match = matchPolls
    .map(".match")
    .mapError -> {
      home_score: "",
      away_score: "",
      home_player_name: "",
      away_player_name: ""
    }
    .toProperty()

  message = match.map(".comment")
    .skipDuplicates()
    .map (value) -> value || ""

  messagePresent = message.not().not()

  homeScore = match.map(".home_score")
  awayScore = match.map(".away_score")

  homePlayerName = match.map(".home_player_name")
  awayPlayerName = match.map(".away_player_name")

  homePlayerAvatarUrl = match.map(".home_player_avatar_url").skipDuplicates()
  awayPlayerAvatarUrl = match.map(".away_player_avatar_url").skipDuplicates()

  #############
  # Rendering #
  #############

  messagePresent
    .assign($(".scoreboard-message-area"), "toggleClass", "message-present")
  message.assign($(".scoreboard-message"), "text")

  homeService = match.map(".home_player_service")
    .skipDuplicates().toProperty()
  awayService = homeService.not()

  awayService.assign($(".scoreboard-away-player"), "toggleClass", "has-service")
  homeService.assign($(".scoreboard-home-player"), "toggleClass", "has-service")

  homeScore.assign $(".scoreboard-home-player-score"), "text"
  awayScore.assign $(".scoreboard-away-player-score"), "text"

  homePlayerName.assign $(".scoreboard-home-player-name"), "text"
  awayPlayerName.assign $(".scoreboard-away-player-name"), "text"

  homePlayerAvatarUrl
    .map (url) -> "url(#{url})"
    .assign $(".scoreboard-home-player-avatar"), "css", "background-image"
  awayPlayerAvatarUrl
    .map (url) -> "url(#{url})"
    .assign $(".scoreboard-away-player-avatar"), "css", "background-image"
