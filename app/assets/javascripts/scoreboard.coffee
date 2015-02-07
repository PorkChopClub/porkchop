$ ->
  initialFetch = Bacon.once { url: '/api/ongoing_match.json' }

  homePlayerPoints = $('.scoreboard-home-player')
    .asEventStream('click')
    .map -> { url: '/api/ongoing_match/home_point.json', type: 'PUT' }

  awayPlayerPoints = $('.scoreboard-away-player')
    .asEventStream('click')
    .map -> { url: '/api/ongoing_match/away_point.json', type: 'PUT' }

  finalization = $('.scoreboard-finished-popup')
    .asEventStream('click', 'button')
    .map -> { url: '/api/ongoing_match/finalize.json', type: 'PUT' }

  match = Bacon.mergeAll(initialFetch,
                         awayPlayerPoints,
                         homePlayerPoints,
                         finalization).ajax().map(".match")

  match.map(".finished")
    .assign $(".scoreboard-finished-popup"), "toggleClass", "active"

  match.map(".home_score")
    .assign $(".scoreboard-home-player-score"), "text"
  match.map(".away_score")
    .assign $(".scoreboard-away-player-score"), "text"

  match.map(".home_player_name")
    .assign $(".scoreboard-home-player-name"), "text"
  match.map(".away_player_name")
    .assign $(".scoreboard-away-player-name"), "text"

  finalization.onValue (final) ->
    window.location.href = "/matches/new" if final
