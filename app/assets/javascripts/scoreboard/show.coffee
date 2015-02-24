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

  gamePoint = match.map(".game_point")
  homeGamePoint = gamePoint.map (player) -> player == "home"
  awayGamePoint = gamePoint.map (player) -> player == "away"

  homeScore = match.map(".home_score")
  awayScore = match.map(".away_score")

  homePlayerName = match.map(".home_player_name")
  awayPlayerName = match.map(".away_player_name")

  homePlayerAvatarUrl = match.map(".home_player_avatar_url").skipDuplicates()
  awayPlayerAvatarUrl = match.map(".away_player_avatar_url").skipDuplicates()

  homeService = match.map(".home_player_service").toProperty()
  awayService = homeService.not()

  awayService.assign($(".scoreboard-away-player"), "toggleClass", "has-service")
  homeService.assign($(".scoreboard-home-player"), "toggleClass", "has-service")

  awayGamePoint.assign($(".scoreboard-away-player"), "toggleClass", "game-point")
  homeGamePoint.assign($(".scoreboard-home-player"), "toggleClass", "game-point")

  homeScore.assign $(".scoreboard-home-player-score"), "text"
  awayScore.assign $(".scoreboard-away-player-score"), "text"

  homePlayerName.assign $(".scoreboard-home-player-name"), "text"
  awayPlayerName.assign $(".scoreboard-away-player-name"), "text"

  homePlayerAvatarUrl
    .map (url) -> "url(#{url})"
    .assign $(".scoreboard-home-player"), "css", "background-image"
  awayPlayerAvatarUrl
    .map (url) -> "url(#{url})"
    .assign $(".scoreboard-away-player"), "css", "background-image"

  matchPolls
    .map -> false
    .mapError -> true
    .toProperty true
    .assign $(".scoreboard-no-game-message"), "toggleClass", "active"
