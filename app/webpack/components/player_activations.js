import { select } from 'lodash';

$(function() {
  if (!$('.player-activations').length) { return; }

  let activePlayerList = $('.active-players-list');
  let inactivePlayerList = $('.inactive-players-list');

  let initialFetch = Bacon.once({ url: '/api/activations' });

  let activations = inactivePlayerList
    .asEventStream('click', 'li')
    .map(function(event) {
      let id = $(event.target).data('id');
      return { url: `/api/activations/${id}/activate.json`, type: 'PUT' };
    });

  let deactivations = activePlayerList
    .asEventStream('click', 'li')
    .map(function(event) {
      let id = $(event.target).data('id');
      return { url: `/api/activations/${id}/deactivate.json`, type: 'PUT' };
    });

  let players = Bacon.mergeAll([initialFetch, activations, deactivations])
    .ajax()
    .map(".players");

  let activePlayers = players
    .map(players => select(players, player => player.active));

  let inactivePlayers = players
    .map(players => select(players, player => !player.active));

  activePlayers.onValue(players => {
    activePlayerList.empty();
    for (let i = 0; i < players.length; i++) {
      let player = players[i];
      activePlayerList.append(`<li data-id=\"${player.id}\">${player.name}</li>`);
    }
  });

  inactivePlayers.onValue(players => {
    inactivePlayerList.empty();
    for (let i = 0; i < players.length; i++) {
      let player = players[i];
      inactivePlayerList.append(`<li data-id=\"${player.id}\">${player.name}</li>`);
    }
  });
});
