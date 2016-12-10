import {
  homeScore,
  awayScore,
  homeName,
  awayName,
  homePortrait,
  awayPortrait
} from '../observables/match'

const ongoingMatchComponent = ($el, match) => {
  homeName(match).assign($el.find('.ongoing-match-player.home .name'), 'text')
  homeScore(match).assign($el.find('.ongoing-match-player.home .score'), 'text')
  homePortrait(match)
    .map((url) => `url(${url})`)
    .assign($el.find('.ongoing-match-player.home .portrait'), 'css', 'background-image')

  awayName(match).assign($el.find('.ongoing-match-player.away .name'), 'text')
  awayScore(match).assign($el.find('.ongoing-match-player.away .score'), 'text')
}

export default ongoingMatchComponent
