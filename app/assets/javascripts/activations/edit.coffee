$ ->
  return unless $('.player-activations').length

  initialFetch = Bacon.once({ url: '/api/activations' })

  activations = $*{ url: '/api/ongoing_match/away_point.json', type: 'PUT' }
  deactivations = { url: '/api/ongoing_match/away_point.json', type: 'PUT' }

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
      activePlayerList.append "<li data-id=\"#{player.id}\">#{player.name}</li>"

  inactivePlayers.onValue (players) ->
    inactivePlayerList.empty()
    for player in players
      inactivePlayerList.append "<li data-id=\"#{player.id}\">#{player.name}</li>"
