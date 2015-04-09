$ ->
  return unless $('.player-activations').length

  activePlayerList = $('.active-players-list')
  inactivePlayerList = $('.inactive-players-list')

  initialFetch = Bacon.once({ url: '/api/activations' })

  activations = inactivePlayerList
    .asEventStream('click', 'li')
    .map (event) ->
      id = $(event.target).data('id')
      { url: "/api/activations/#{id}/activate.json", type: 'PUT' }

  deactivations = activePlayerList
    .asEventStream('click', 'li')
    .map (event) ->
      id = $(event.target).data('id')
      { url: "/api/activations/#{id}/deactivate.json", type: 'PUT' }

  players = Bacon.mergeAll([initialFetch, activations, deactivations])
    .ajax()
    .map(".players")

  activePlayers = players
    .map (players) -> _.select(players, (player) -> player.active)

  inactivePlayers = players
    .map (players) -> _.select(players, (player) -> !player.active)

  activePlayers.onValue (players) ->
    activePlayerList.empty()
    for player in players
      activePlayerList.append "<li data-id=\"#{player.id}\">#{player.name}</li>"

  inactivePlayers.onValue (players) ->
    inactivePlayerList.empty()
    for player in players
      inactivePlayerList.append "<li data-id=\"#{player.id}\">#{player.name}</li>"
