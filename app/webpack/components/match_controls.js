import $ from 'jquery';
import Bacon from 'baconjs';
$.fn.asEventStream = Bacon.$.asEventStream;

$(function() {
  if (!$('.match-controls').length) { return; }

  let ajaxOptions = { url: '/api/ongoing_match.json' };

  let homePlayerPoints = $('.match-controls-home-player')
    .asEventStream('click')
    .map(function() {
      ga('send', 'event', 'button', 'click', 'home point');
      return { url: '/api/ongoing_match/home_point.json', type: 'PUT' };
    });

  let awayPlayerPoints = $('.match-controls-away-player')
    .asEventStream('click')
    .map(function() {
      ga('send', 'event', 'button', 'click', 'away point');
      return { url: '/api/ongoing_match/away_point.json', type: 'PUT' };
    });

  let serviceToggle = $('.match-controls-toggle-service')
    .asEventStream('click')
    .map(function() {
      ga('send', 'event', 'button', 'click', 'toggle service');
      return { url: '/api/ongoing_match/toggle_service.json', type: 'PUT' };
    });

  let rewinds = $('.match-controls-rewind')
    .asEventStream('click')
    .map(function() {
      ga('send', 'event', 'button', 'click', 'rewind');
      return { url: '/api/ongoing_match/rewind.json', type: 'PUT' };
    });

  let finalization = $('.match-controls-finalize-match')
    .asEventStream('click')
    .map(function() {
      ga('send', 'event', 'button', 'click', 'finalize match');
      return { url: '/api/ongoing_match/finalize.json', type: 'PUT' };
    });

  let cancellations = $('.match-controls-cancel-match')
    .asEventStream('click')
    .map(function() {
      ga('send', 'event', 'button', 'click', 'cancel match');
      return { url: '/api/ongoing_match.json', type: 'DELETE' };
    });

  let matchmakes = $('.match-controls-matchmake')
    .asEventStream('click')
    .map(function() {
      ga('send', 'event', 'button', 'click', 'matchmake');
      return { url: '/api/ongoing_match/matchmake.json', type: 'PUT' };
    });

  let data = Bacon
    .mergeAll(
      Bacon.ajaxPoll(ajaxOptions, 3000),
      Bacon.mergeAll(
        homePlayerPoints,
        awayPlayerPoints,
        serviceToggle,
        rewinds,
        finalization,
        cancellations,
        matchmakes
      ).serialAjax()
    );

  let match = data.map(".match")
    .mapError(() => ({
      home_score: 0,
      away_score: 0,
      home_player_name: "???",
      away_player_name: "???",
      finished: false,
      home_player_service: true,
      away_player_service: false
    }) );

  let nextMatch = data.map(".next_match");
  let nextMatchInfo = nextMatch.map(function(m) {
    if (m.players.length === 2) {
      return `Next Match: ${m.players[0].name} vs ${m.players[1].name}`;
    } else {
      return "";
    }
  });
  nextMatchInfo.assign($(".next-match"), "text");

  let matchId = match.map(".id").toProperty();

  let matchHomeScore = match.map(".home_score").toProperty();
  let matchAwayScore = match.map(".away_score").toProperty();

  let matchHomeName = match.map(".home_player_name").toProperty();
  let matchAwayName = match.map(".away_player_name").toProperty();

  let matchHomeService = match.map(".home_player_service").toProperty();
  let matchAwayService = match.map(".away_player_service").toProperty();

  let matchFinished = match.map(".finished").toProperty();
  let matchFinalized = match.map(".finalized").toProperty();
  let matchDeleted = match.map(".deleted").toProperty();

  matchFinalized.assign($(".match-controls-cancel-match"), "prop", "disabled");

  matchFinished.not()
    .assign(
      $(".match-controls-finalize-match, .match-controls-show-finalize-match"),
      "prop",
      "disabled"
    );

  matchHomeScore.assign($(".match-controls-home-player-score"), "text");
  matchAwayScore.assign($(".match-controls-away-player-score"), "text");

  matchHomeName.assign($(".match-controls-home-player-name"), "text");
  matchAwayName.assign($(".match-controls-away-player-name"), "text");

  matchAwayService.assign(
    $(".match-controls-away-player"),
      "toggleClass",
      "has-service"
  );
  matchHomeService.assign(
    $(".match-controls-home-player"),
    "toggleClass",
    "has-service"
  );
});
