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

  matchmakes = $('.match-controls-matchmake')
    .asEventStream('click')
    .map ->
      ga 'send', 'event', 'button', 'click', 'matchmake'
      { url: '/api/ongoing_match/matchmake.json', type: 'PUT' }

  data = Bacon
    .mergeAll(
      initialFetch,
      polling,
      homePlayerPoints,
      awayPlayerPoints,
      serviceToggle,
      rewinds,
      finalization,
      cancellations,
      matchmakes
    ).ajax()

  match = data.map(".match")
    .mapError -> {
      home_score: 0,
      away_score: 0,
      home_player_name: "???",
      away_player_name: "???",
      finished: false,
      home_player_service: true,
      away_player_service: false
    }

  nextMatch = data.map(".next_match")
  nextMatchInfo = nextMatch.map (m) ->
    if m.players.length == 2
      "Next Match: #{m.players[0].name} vs #{m.players[1].name}"
    else
      ""
  nextMatchInfo.assign $(".next-match"), "text"

  matchId = match.map(".id").toProperty()

  matchHomeScore = match.map(".home_score").toProperty()
  matchAwayScore = match.map(".away_score").toProperty()

  matchHomeName = match.map(".home_player_name").toProperty()
  matchAwayName = match.map(".away_player_name").toProperty()

  matchHomeService = match.map(".home_player_service").toProperty()
  matchAwayService = match.map(".away_player_service").toProperty()

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

  matchAwayService.assign(
    $(".match-controls-away-player"),
      "toggleClass",
      "has-service"
  )
  matchHomeService.assign(
    $(".match-controls-home-player"),
    "toggleClass",
    "has-service"
  )
