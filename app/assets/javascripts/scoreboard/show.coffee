#= require match_stream
$ ->
  return unless $('.scoreboard').length

  ajaxOptions = { url: '/api/ongoing_match.json' }
  matchPolls = Bacon.mergeAll([Bacon.interval(300, ajaxOptions),
                               Bacon.once(ajaxOptions)]).ajax()

  match = matchPolls
    .map(".match")
    .mapError -> {
      home_score: "",
      away_score: "",
      home_player_name: "",
      away_player_name: "",
      comment: "",
      instructions: ""
    }
    .toProperty()

  match = new MatchStream(match)

  #############
  # Rendering #
  #############

  match.commentPresent
    .assign($(".scoreboard-message-area"), "toggleClass", "message-present")
  match.comment
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

  backgroundmap = (url) -> url? ? "none" : "url(#{url})"
  match.homePlayerAvatarUrl
    .map backgroundmap
    .assign $(".scoreboard-home-player-avatar"), "css", "background-image"
  match.awayPlayerAvatarUrl
    .map backgroundmap
    .assign $(".scoreboard-away-player-avatar"), "css", "background-image"
