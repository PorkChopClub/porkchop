import {
  homeScore,
  awayScore,
  homeName,
  awayName,
  homePortrait,
  awayPortrait,
  homeService,
  awayService
} from '../observables/match'

const ongoingMatchComponent = ($el, match) => {
  homeName(match).assign($el.find('.ongoing-match-player.home .name'), 'text')
  homeScore(match).assign($el.find('.ongoing-match-player.home .score'), 'text')
  homeService(match).assign($el.find('.ongoing-match-player.home'), 'toggleClass', 'has-service')
  homePortrait(match)
    .map((url) => `url(${url})`)
    .assign($el.find('.ongoing-match-player.home .portrait'), 'css', 'background-image')

  awayName(match).assign($el.find('.ongoing-match-player.away .name'), 'text')
  awayScore(match).assign($el.find('.ongoing-match-player.away .score'), 'text')
  awayService(match).assign($el.find('.ongoing-match-player.away'), 'toggleClass', 'has-service')
  awayPortrait(match)
    .map((url) => `url(${url})`)
    .assign($el.find('.ongoing-match-player.away .portrait'), 'css', 'background-image')
}

export default ongoingMatchComponent
