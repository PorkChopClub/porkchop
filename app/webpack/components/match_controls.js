import $ from 'jquery'
import Bacon from 'baconjs'
$.fn.asEventStream = Bacon.$.asEventStream

$(() => {
  if (!$('.match-controls').length) { return }

  const ajaxOptions = { url: '/api/ongoing_match.json' }

  const homePlayerPoints = $('.match-controls-home-player')
    .asEventStream('click')
    .map(() => {
      ga('send', 'event', 'button', 'click', 'home point')
      return { url: '/api/ongoing_match/home_point.json', type: 'PUT' }
    })

  const awayPlayerPoints = $('.match-controls-away-player')
    .asEventStream('click')
    .map(() => {
      ga('send', 'event', 'button', 'click', 'away point')
      return { url: '/api/ongoing_match/away_point.json', type: 'PUT' }
    })

  const serviceToggle = $('.match-controls-toggle-service')
    .asEventStream('click')
    .map(() => {
      ga('send', 'event', 'button', 'click', 'toggle service')
      return { url: '/api/ongoing_match/toggle_service.json', type: 'PUT' }
    })

  const rewinds = $('.match-controls-rewind')
    .asEventStream('click')
    .map(() => {
      ga('send', 'event', 'button', 'click', 'rewind')
      return { url: '/api/ongoing_match/rewind.json', type: 'PUT' }
    })

  const finalization = $('.match-controls-finalize-match')
    .asEventStream('click')
    .map(() => {
      ga('send', 'event', 'button', 'click', 'finalize match')
      return { url: '/api/ongoing_match/finalize.json', type: 'PUT' }
    })

  const cancellations = $('.match-controls-cancel-match')
    .asEventStream('click')
    .map(() => {
      ga('send', 'event', 'button', 'click', 'cancel match')
      return { url: '/api/ongoing_match.json', type: 'DELETE' }
    })

  const matchmakes = $('.match-controls-matchmake')
    .asEventStream('click')
    .map(() => {
      ga('send', 'event', 'button', 'click', 'matchmake')
      return { url: '/api/ongoing_match/matchmake.json', type: 'PUT' }
    })

  const data = Bacon
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
    )

  const match = data.map('.match')
    .mapError(() => ({
      home_score: 0,
      away_score: 0,
      home_player_name: '???',
      away_player_name: '???',
      finished: false,
      home_player_service: true,
      away_player_service: false
    }))

  const nextMatch = data.map('.next_match')
  const nextMatchInfo = nextMatch.map((m) => {
    if (m.players.length === 2) {
      return `Next Match: ${m.players[0].name} vs ${m.players[1].name}`
    }
    return ''
  })
  nextMatchInfo.assign($('.next-match'), 'text')

  const matchHomeScore = match.map('.home_score').toProperty()
  const matchAwayScore = match.map('.away_score').toProperty()

  const matchHomeName = match.map('.home_player_name').toProperty()
  const matchAwayName = match.map('.away_player_name').toProperty()

  const matchHomeService = match.map('.home_player_service').toProperty()
  const matchAwayService = match.map('.away_player_service').toProperty()

  const matchFinished = match.map('.finished').toProperty()
  const matchFinalized = match.map('.finalized').toProperty()

  matchFinalized.assign($('.match-controls-cancel-match'), 'prop', 'disabled')

  matchFinished.not()
    .assign(
      $('.match-controls-finalize-match, .match-controls-show-finalize-match'),
      'prop',
      'disabled'
    )

  matchHomeScore.assign($('.match-controls-home-player-score'), 'text')
  matchAwayScore.assign($('.match-controls-away-player-score'), 'text')

  matchHomeName.assign($('.match-controls-home-player-name'), 'text')
  matchAwayName.assign($('.match-controls-away-player-name'), 'text')

  matchAwayService.assign(
    $('.match-controls-away-player'),
      'toggleClass',
      'has-service'
  )
  matchHomeService.assign(
    $('.match-controls-home-player'),
    'toggleClass',
    'has-service'
  )
})
