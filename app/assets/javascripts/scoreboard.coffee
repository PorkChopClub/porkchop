$ ->
  return unless $('.scoreboard').length

  pollingEnabled = Bacon.constant window.location.href.indexOf("sync=1") > -1

  matchPolls = Bacon.interval 1000, { url: '/api/ongoing_match.json' }
    .filter pollingEnabled

  initialFetch = Bacon.once { url: '/api/ongoing_match.json' }

  homePlayerPoints = $('.scoreboard-home-player')
    .asEventStream('click')
    .map -> { url: '/api/ongoing_match/home_point.json', type: 'PUT' }

  awayPlayerPoints = $('.scoreboard-away-player')
    .asEventStream('click')
    .map -> { url: '/api/ongoing_match/away_point.json', type: 'PUT' }

  rewinds = $('.scoreboard-rewind')
    .asEventStream('click')
    .map -> { url: '/api/ongoing_match/rewind.json', type: 'PUT' }

  finalization = $('.scoreboard-finished-popup')
    .asEventStream('click', 'button')
    .map -> { url: '/api/ongoing_match/finalize.json', type: 'PUT' }

  cancellations = $('.scoreboard-cancel-game')
    .asEventStream('click')
    .map -> { url: '/api/ongoing_match.json', type: 'DELETE' }

  match = Bacon.mergeAll(initialFetch,
                         awayPlayerPoints,
                         homePlayerPoints,
                         matchPolls,
                         rewinds,
                         cancellations,
                         finalization).ajax().map(".match")

  finalized = match.map(".finalized")
  deleted = match.map(".deleted")
  Bacon.mergeAll(finalized, deleted)
    .onValue (final) -> window.location.href = "/matches/new" if final

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
