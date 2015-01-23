$ ->
  players = Bacon.constant [
    "Jared Norman"
    "Gray Gilmore"
    "Sean Taylor"
    "Naomi Aro"
    "Sonmaz Zehtabi"
    "Clarke Brunsdon"
    "Kyria Brown"
    "Adam Mueller"
    "Chris Todorov"
    "Richard Wilson"
    "Brendan Deere"
    "Kevin Attfield"
    "Chris Kelly"
    "John Hawthorn"
  ]

  playerActivations = $('.player-list-inactive-players')
    .asEventStream('click', '.player-list-player')
    .map (event) -> $(event.target).text()
    .map (player) ->
      (playerList) ->
        playerList = _.clone(playerList)
        playerList.push(player)
        playerList

  playerDeactivations = $('.player-list-active-players')
    .asEventStream('click', '.player-list-player')
    .map (event) -> $(event.target).text()
    .map (player) ->
      (playerList) ->
        _.without playerList, player

  activePlayers = playerActivations
    .merge(playerDeactivations)
    .scan [], (activePlayers, change) -> change(activePlayers)

  inactivePlayers = Bacon.combineWith _.difference, players, activePlayers

  homePlayer = activePlayers.map (playerList) -> playerList[0]

  awayPlayer = activePlayers.map (playerList) -> playerList[1]

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

  matches = homePlayerScoring
    .merge(awayPlayerScoring)
    .merge(rewinds)
    .scan [[]], (matchList, change) -> [change(matchList[0])]

  ongoingMatch = matches.map (matchList) -> matchList[0]

  homeScore = ongoingMatch
    .map (scoringList) ->
      _.filter(scoringList, (who) -> who == 'home').length

  awayScore = ongoingMatch
    .map (scoringList) ->
      _.filter(scoringList, (who) -> who == 'away').length

  service = ongoingMatch
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
  homePlayer.assign $('.scoreboard-home-player-name'), 'text'
  awayPlayer.assign $('.scoreboard-away-player-name'), 'text'

  # Render active players.
  activePlayers
    .onValue (activePlayers) ->
      $activePlayerList = $('.player-list-active-players')
      $activePlayerList.empty()
      _.each activePlayers, (player) ->
        $activePlayerList.append """
          <div class="player-list-player">#{player}</div>
        """
  # Render inactive players.
  inactivePlayers
    .onValue (inactivePlayers) ->
      $inactivePlayerList = $('.player-list-inactive-players')
      $inactivePlayerList.empty()
      _.each inactivePlayers, (player) ->
        $inactivePlayerList.append """
          <div class="player-list-player">#{player}</div>
        """
