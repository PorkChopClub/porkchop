$ ->
  return unless $('.match-controls').length

  initialFetch = Bacon.once { url: '/api/ongoing_match.json' }

  homePlayerPoints = $('.match-controls-home-player')
    .asEventStream('click')
    .map -> { url: '/api/ongoing_match/home_point.json', type: 'PUT' }

  awayPlayerPoints = $('.match-controls-away-player')
    .asEventStream('click')
    .map -> { url: '/api/ongoing_match/away_point.json', type: 'PUT' }

  rewinds = $('.match-controls-rewind')
    .asEventStream('click')
    .map -> { url: '/api/ongoing_match/rewind.json', type: 'PUT' }

  finalization = $('.match-controls-finalize')
    .asEventStream('click')
    .map -> { url: '/api/ongoing_match/finalize.json', type: 'PUT' }

  cancellations = $('.match-controls-cancel-game')
    .asEventStream('click')
    .map -> { url: '/api/ongoing_match.json', type: 'DELETE' }

  match = Bacon.mergeAll(initialFetch,
                         homePlayerPoints,
                         awayPlayerPoints,
                         rewinds,
                         finalization,
                         cancellations).ajax().map(".match")

  match.map(".home_score")
    .assign $(".match-controls-home-player-score"), "text"
  match.map(".away_score")
    .assign $(".match-controls-away-player-score"), "text"

  match.map(".home_player_name")
    .assign $(".match-controls-home-player-name"), "text"
  match.map(".away_player_name")
    .assign $(".match-controls-away-player-name"), "text"

  finalized = match.map(".finalized")
  deleted = match.map(".deleted")
  Bacon.mergeAll(finalized, deleted)
    .onValue (final) -> window.location.href = "/matches/new" if final
