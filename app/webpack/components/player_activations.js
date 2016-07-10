import $ from 'jquery'
import Bacon from 'baconjs'
import { filter } from 'lodash'
$.fn.asEventStream = Bacon.$.asEventStream

$(function() {
  if (!$('.player-activations').length) { return }

  const activePlayerList = $('.active-players-list')
  const inactivePlayerList = $('.inactive-players-list')

  const initialFetch = Bacon.once({ url: '/api/activations' })

  const activations = inactivePlayerList
    .asEventStream('click', 'li')
    .map(function(event) {
      const id = $(event.target).data('id')
      return { url: `/api/activations/${id}/activate.json`, type: 'PUT' }
    })

  const deactivations = activePlayerList
    .asEventStream('click', 'li')
    .map(function(event) {
      const id = $(event.target).data('id')
      return { url: `/api/activations/${id}/deactivate.json`, type: 'PUT' }
    })

  const players = Bacon.mergeAll([initialFetch, activations, deactivations])
    .ajax()
    .map('.players')

  const activePlayers = players
    .map(players => filter(players, player => player.active))

  const inactivePlayers = players
    .map(players => filter(players, player => !player.active))

  activePlayers.onValue(players => {
    activePlayerList.empty()
    for (let i = 0; i < players.length; i++) {
      const player = players[i]
      activePlayerList.append(`<li data-id=\"${player.id}\">${player.name}</li>`)
    }
  })

  inactivePlayers.onValue(players => {
    inactivePlayerList.empty()
    for (let i = 0; i < players.length; i++) {
      const player = players[i]
      inactivePlayerList.append(`<li data-id=\"${player.id}\">${player.name}</li>`)
    }
  })
})
