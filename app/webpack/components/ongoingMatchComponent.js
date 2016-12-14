import {
  homeScore,
  awayScore,
  homeName,
  awayName,
  homePortrait,
  awayPortrait,
  homeServiceState,
  awayServiceState
} from '../observables/match'

const ongoingMatchComponent = ($el, match) => {
  const setPlayerServiceState = (player, serviceState) => {
    serviceState
      .scan({}, ({ currentState: previousState }, currentState) => ({ currentState, previousState }))
      .onValue(({ currentState, previousState }) => {
        $el.find(`.ongoing-match-player.${player}`).removeClass(previousState)
        $el.find(`.ongoing-match-player.${player}`).addClass(currentState)
      })
  }

  homeName(match).assign($el.find('.ongoing-match-player.home .name'), 'text')
  homeScore(match).assign($el.find('.ongoing-match-player.home .score'), 'text')
  homePortrait(match)
    .map((url) => `url(${url})`)
    .assign($el.find('.ongoing-match-player.home .portrait'), 'css', 'background-image')
  setPlayerServiceState('home', homeServiceState(match))

  awayName(match).assign($el.find('.ongoing-match-player.away .name'), 'text')
  awayScore(match).assign($el.find('.ongoing-match-player.away .score'), 'text')
  awayPortrait(match)
    .map((url) => `url(${url})`)
    .assign($el.find('.ongoing-match-player.away .portrait'), 'css', 'background-image')
  setPlayerServiceState('away', awayServiceState(match))
}

export default ongoingMatchComponent
