$ ->
  return unless $('.player-activations').length

  initialFetch = Bacon.once({ url: '/api/activations' })

  players = Bacon.mergeAll([initialFetch])
    .ajax()
    .map(".players")

  activePlayers = players
    .map (players) -> _.select(players, (player) -> player.active)

  inactivePlayers = players
    .map (players) -> _.select(players, (player) -> !player.active)


  activePlayerList = $('.active-players-list')
  inactivePlayerList = $('.inactive-players-list')

  activePlayers.onValue (players) ->
    activePlayerList.empty()
    for player in players
      activePlayerList.append "<li>#{player.name}</li>"

  inactivePlayers.onValue (players) ->
    inactivePlayerList.empty()
    for player in players
      inactivePlayerList.append "<li>#{player.name}</li>"
