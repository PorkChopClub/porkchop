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
    .log()

  activePlayers = playerActivations
    .scan [], (activePlayers, player) ->
      activePlayers.push player
      activePlayers

  inactivePlayers = Bacon.combineWith _.difference, players, activePlayers

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
