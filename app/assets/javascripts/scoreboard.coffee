playerIdFromName = (name, playerList) ->
  _.find(playerList, (player) -> player.name == name)?.id

playerNameFromId = (id, playerList) ->
  _.find(playerList, (player) -> player.id == id)?.name

$ ->

  players = Bacon
    .once { url: "/api/players.json" }
    .ajax()
    .map (data) -> data["players"]
    .toProperty []

  playerIds = players
    .map (players) ->
      _.map players, (player) -> player.id

  playerActivations = $('.player-list-unselected-players')
    .asEventStream('click', '.player-list-player')
    .map (event) -> $(event.target).text()
    .combine(players, playerIdFromName)
    .map (id) ->
      (playerList) ->
        playerList = _.clone(playerList)
        playerList.push(id)
        playerList

  selectedPlayerIds = playerActivations
    .scan [], (selectedPlayerIds, change) -> change(selectedPlayerIds)

  unselectedPlayers = Bacon
    .combineWith _.difference, playerIds, selectedPlayerIds
    .combine players, (ids, players) ->
      _.filter players, (player) ->
        _.include(ids, player.id)

  selectedPlayerCount = selectedPlayerIds
    .map (players) -> players.length
  playersSelected = selectedPlayerCount
    .map (count) -> count == 2

  homePlayerId = selectedPlayerIds.map (playerList) -> playerList[0]

  awayPlayerId = selectedPlayerIds.map (playerList) -> playerList[1]

  homePlayerServiceSelection = $('.service-selection-overlay')
    .asEventStream 'click', '.home-player'
    .map -> "home"

  awayPlayerServiceSelection = $('.service-selection-overlay')
    .asEventStream 'click', '.away-player'
    .map -> "away"

  playerServingFirst = Bacon
    .mergeAll [homePlayerServiceSelection, awayPlayerServiceSelection]
    .take(1)
    .toProperty(null)

  serviceSelected = playerServingFirst.not().not()

  homePlayerScoring = $('.scoreboard-home-player')
    .asEventStream('click')
    .map ->
      (match) ->
        match = _.cloneDeep(match)
        match.push 'home'
        match

  awayPlayerScoring = $('.scoreboard-away-player')
    .asEventStream('click')
    .map ->
      (match) ->
        match = _.cloneDeep(match)
        match.push 'away'
        match

  rewinds = $('.scoreboard-rewind')
    .asEventStream('click')
    .map ->
      (match) ->
        match = _.cloneDeep(match)
        match.pop()
        match

  match = homePlayerScoring
    .merge(awayPlayerScoring)
    .merge(rewinds)
    .scan [], (match, change) -> change(match)

  serviceOrder = playerServingFirst
    .map (player) ->
      if player == "away"
        ["away", "home"]
      else
        ["home", "away"]

  service = match
    .map (scoringList) -> scoringList.length % 4
    .combine serviceOrder, (serviceCount, serviceOrder) ->
       serviceOrder[serviceCount >> 1]

  homeServing = service.map (service) -> service == 'home'
  awayServing = service.map (service) -> service == 'away'

  homeScore = match
    .map (scoringList) ->
      _.filter(scoringList, (who) -> who == 'home').length

  awayScore = match
    .map (scoringList) ->
      _.filter(scoringList, (who) -> who == 'away').length

  # Render player selection
  selectedPlayerCount
    .map (count) ->
      if count == 0
        "Choose the home player!"
      else
        "Choose the away player!"
    .assign $('.player-selection-message'), 'text'

  playersSelected
    .assign $('.player-selection-overlay'), 'toggleClass', 'finished'

  # Render service selection.
  playersSelected
    .assign $('.service-selection-overlay'), 'toggleClass', 'started'
  homePlayerId
    .combine players, playerNameFromId
    .assign $('.service-selection-overlay .home-player'), 'text'
  awayPlayerId
    .combine players, playerNameFromId
    .assign $('.service-selection-overlay .away-player'), 'text'
  serviceSelected
    .assign $('.service-selection-overlay'), 'toggleClass', 'finished'

  # Render service indication.
  homeServing
    .assign $('.scoreboard-home-player'), 'toggleClass', 'has-service'
  awayServing
    .assign $('.scoreboard-away-player'), 'toggleClass', 'has-service'

  # Render player scores.
  homeScore.assign $('.scoreboard-home-player-score'), 'text'
  awayScore.assign $('.scoreboard-away-player-score'), 'text'

  # Render player names.
  homePlayerId
    .combine players, playerNameFromId
    .assign $('.scoreboard-home-player-name'), 'text'
  awayPlayerId
    .combine players, playerNameFromId
    .assign $('.scoreboard-away-player-name'), 'text'

  # Render unselected players.
  unselectedPlayers
    .onValue (unselectedPlayers) ->
      $unselectedPlayerList = $('.player-list-unselected-players')
      $unselectedPlayerList.empty()
      _.each unselectedPlayers, (player) ->
        $unselectedPlayerList.append """
          <div class="player-list-player">#{player.name}</div>
        """
