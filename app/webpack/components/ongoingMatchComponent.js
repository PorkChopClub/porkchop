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
      .scan(
        {},
        ({ currentState: previousState }, currentState) => ({ currentState, previousState })
      )
      .onValue(({ currentState, previousState }) => {
        const $player = $el.find(`.ongoing-match-player.${player}`)
        if (currentState === 'serving' &&
            (previousState === 'no-service' || previousState === 'receiving')) {
          $player.removeClass('receiving')
          $player.addClass(currentState)

          setTimeout(() => {
            $player.removeClass(currentState)
            $player.addClass('receiving')
          }, 200)

          setTimeout(() => {
            $player.removeClass('receiving')
            $player.addClass(currentState)
          }, 400)

          setTimeout(() => {
            $player.removeClass(currentState)
            $player.addClass('receiving')
          }, 600)

          setTimeout(() => {
            $player.removeClass('receiving')
            $player.addClass(currentState)
          }, 800)

          setTimeout(() => {
            $player.removeClass(currentState)
            $player.addClass('receiving')
          }, 1000)

          setTimeout(() => {
            $player.removeClass('receiving')
            $player.addClass(currentState)
          }, 1200)
        } else {
          $player.removeClass(previousState)
          $player.addClass(currentState)
        }
      })
  }

  const refreshScore = (player) =>
    (score) => {
      const $score = $el.find(`.ongoing-match-player.${player} .score`)
      $score.addClass('tiny')

      setTimeout(() => {
        $score
          .text(score)
          .removeClass('tiny')
      }, 150)
    }

  homeName(match).assign($el.find('.ongoing-match-player.home .name'), 'text')
  homePortrait(match)
    .map((url) => `url(${url})`)
    .assign($el.find('.ongoing-match-player.home .portrait'), 'css', 'background-image')
  setPlayerServiceState('home', homeServiceState(match))
  homeScore(match).onValue(refreshScore('home'))

  awayName(match).assign($el.find('.ongoing-match-player.away .name'), 'text')
  awayPortrait(match)
    .map((url) => `url(${url})`)
    .assign($el.find('.ongoing-match-player.away .portrait'), 'css', 'background-image')
  setPlayerServiceState('away', awayServiceState(match))
  awayScore(match).onValue(refreshScore('away'))
}

export default ongoingMatchComponent
