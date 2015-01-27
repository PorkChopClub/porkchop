playerIdFromName = (name, playerList) ->
  _.find(playerList, (player) -> player.name == name)?.id

playerNameFromId = (id, playerList) ->
  _.find(playerList, (player) -> player.id == id)?.name

$ ->
  playersRequest = $.ajax
    url: "/api/players.json"

  players = Bacon
    .fromPromise(playersRequest)
    .map (data) -> data["players"]
    .toProperty []

  playerActivations = $('.player-list-inactive-players')
    .asEventStream('click', '.player-list-player')
    .map (event) -> $(event.target).text()
    .combine(players, playerIdFromName)
    .map (id) ->
      (playerList) ->
        playerList = _.clone(playerList)
        playerList.push(id)
        playerList

  playerDeactivations = $('.player-list-active-players')
    .asEventStream('click', '.player-list-player')
    .map (event) -> $(event.target).text()
    .combine(players, playerIdFromName)
    .map (id) ->
      (playerList) ->
        _.without playerList, id

  activePlayers = playerActivations
    .scan [], (activePlayers, change) -> change(activePlayers)

  inactivePlayers = Bacon.combineWith _.difference, players, activePlayers

  homePlayerId = activePlayers.map (playerList) -> playerList[0]

  awayPlayerId = activePlayers.map (playerList) -> playerList[1]

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

  homeScore = match
    .map (scoringList) ->
      _.filter(scoringList, (who) -> who == 'home').length

  awayScore = match
    .map (scoringList) ->
      _.filter(scoringList, (who) -> who == 'away').length

  service = match
    .map (scoringList) ->
      if scoringList.length/2 % 2 < 1 then 'home' else 'away'

  homeServing = service.map (service) -> service == 'home'
  awayServing = service.map (service) -> service == 'away'

  # Set service indicator
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

  # Render inactive players.
  players
    .onValue (inactivePlayers) ->
      $inactivePlayerList = $('.player-list-inactive-players')
      $inactivePlayerList.empty()
      _.each inactivePlayers, (player) ->
        $inactivePlayerList.append """
          <div class="player-list-player">#{player.name}</div>
        """
