import './shared';

import $ from 'jquery';

import ongoingMatch from './observables/ongoingMatch';

$(() => {
  ongoingMatch
    .map('.comment')
    .assign(
      $('.scoreboard-message'),
      'text'
    );

  ongoingMatch
    .map('.comment')
    .map((message) => !!message)
    .assign(
      $('.scoreboard-message-area'),
      'toggleClass',
      'message-present'
    );

  ongoingMatch
    .map('.instructions')
    .assign($('.scoreboard-instructions'), 'text');

  ongoingMatch
    .map('.league_match')
    .assign(
      $('.scoreboard-message-area'),
      'toggleClass',
      'league-match'
    );

  ongoingMatch
    .map('.league_match')
    .assign($('.scoreboard-league-match'), 'toggle');

  ongoingMatch
    .map('.away_player_service')
    .assign(
      $('.scoreboard-away-player'),
      'toggleClass',
      'has-service'
    );
  ongoingMatch
    .map('.home_player_service')
    .assign(
      $('.scoreboard-home-player'),
      'toggleClass',
      'has-service'
    );

  ongoingMatch
    .map('.home_score')
    .assign($('.scoreboard-home-player-score'), 'text');
  ongoingMatch
    .map('.away_score')
    .assign($('.scoreboard-away-player-score'), 'text');

  ongoingMatch
    .map('.home_player_name')
    .assign($('.scoreboard-home-player-name'), 'text');
  ongoingMatch
    .map('.away_player_name')
    .assign($('.scoreboard-away-player-name'), 'text');

  let backgroundmap = (url) => (url ? `url(${url})` : 'none')
  ongoingMatch
    .map('.home_player_avatar_url')
    .map(backgroundmap)
    .assign(
      $('.scoreboard-home-player-avatar'),
      'css',
      'background-image'
    );
  ongoingMatch
    .map('.away_player_avatar_url')
    .map(backgroundmap)
    .assign(
      $('.scoreboard-away-player-avatar'),
      'css',
      'background-image'
    );
});
