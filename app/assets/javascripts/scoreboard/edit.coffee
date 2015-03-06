$ ->
  return unless $('.match-controls').length

  initialFetch = Bacon.once { url: '/api/ongoing_match.json' }
  polling = Bacon.interval(3000, { url: '/api/ongoing_match.json' })

  homePlayerPoints = $('.match-controls-home-player')
    .asEventStream('click')
    .map ->
      ga 'send', 'event', 'button', 'click', 'home point'
      { url: '/api/ongoing_match/home_point.json', type: 'PUT' }

  awayPlayerPoints = $('.match-controls-away-player')
    .asEventStream('click')
    .map ->
      ga 'send', 'event', 'button', 'click', 'away point'
      { url: '/api/ongoing_match/away_point.json', type: 'PUT' }

  serviceToggle = $('.match-controls-toggle-service')
    .asEventStream('click')
    .map ->
      ga 'send', 'event', 'button', 'click', 'toggle service'
      { url: '/api/ongoing_match/toggle_service.json', type: 'PUT' }

  rewinds = $('.match-controls-rewind')
    .asEventStream('click')
    .map ->
      ga 'send', 'event', 'button', 'click', 'rewind'
      { url: '/api/ongoing_match/rewind.json', type: 'PUT' }

  finalization = $('.match-controls-finalize-match')
    .asEventStream('click')
    .map ->
      ga 'send', 'event', 'button', 'click', 'finalize match'
      { url: '/api/ongoing_match/finalize.json', type: 'PUT' }

  cancellations = $('.match-controls-cancel-match')
    .asEventStream('click')
    .map ->
      ga 'send', 'event', 'button', 'click', 'cancel match'
      { url: '/api/ongoing_match.json', type: 'DELETE' }

  match = Bacon.mergeAll(initialFetch,
                         polling,
                         homePlayerPoints,
                         awayPlayerPoints,
                         serviceToggle,
                         rewinds,
                         finalization,
                         cancellations).ajax().map(".match")

  overlayCancelled = $('.match-controls-overlay-cancel')
    .asEventStream('click')
    .map -> false

  showCancelMatch = $('.match-controls-show-cancel-match')
    .asEventStream('click')
    .map -> true

  showFinalizeMatch = $('.match-controls-show-finalize-match')
    .asEventStream('click')
    .map -> true

  showingOverlay = Bacon.mergeAll([
    showCancelMatch
    showFinalizeMatch
    overlayCancelled
  ]).toProperty(false)

  showingCancelButton = Bacon.mergeAll(showCancelMatch, overlayCancelled)
    .toProperty(false)

  showingFinalizeButton = Bacon.mergeAll(showFinalizeMatch, overlayCancelled)
    .toProperty(false)

  matchId = match.map(".id").toProperty()

  matchHomeScore = match.map(".home_score").toProperty()
  matchAwayScore = match.map(".away_score").toProperty()

  matchHomeName = match.map(".home_player_name").toProperty()
  matchAwayName = match.map(".away_player_name").toProperty()

  matchHomeService = match.map(".home_player_service").toProperty()

  matchFinished = match.map(".finished").toProperty()
  matchFinalized = match.map(".finalized").toProperty()
  matchDeleted = match.map(".deleted").toProperty()

  matchFinalized.assign $(".match-controls-cancel-match"), "prop", "disabled"

  matchFinished.not()
    .assign(
      $(".match-controls-finalize-match, .match-controls-show-finalize-match"),
      "prop",
      "disabled"
    )

  matchHomeScore.assign $(".match-controls-home-player-score"), "text"
  matchAwayScore.assign $(".match-controls-away-player-score"), "text"

  matchHomeName.assign $(".match-controls-home-player-name"), "text"
  matchAwayName.assign $(".match-controls-away-player-name"), "text"

  matchHomeService.not().assign(
    $(".match-controls-away-player"),
      "toggleClass",
      "has-service"
  )
  matchHomeService.assign(
    $(".match-controls-home-player"),
    "toggleClass",
    "has-service"
  )

  matchDeleted
    .filter (value) -> value
    .onValue -> window.location.assign("/matches/new")

  matchFinalized
    .filter (value) -> value
    .map(matchId)
    .onValue (id) -> window.location.assign("/matches/#{id}")

  showingOverlay.assign $('.match-controls-overlay'), 'toggleClass', 'active'

  showingCancelButton
    .assign $('.match-controls-cancel-match'), 'toggleClass', 'active'

  showingFinalizeButton
    .assign $('.match-controls-finalize-match'), 'toggleClass', 'active'
