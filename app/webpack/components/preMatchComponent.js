import {
  secondsOld,
  homeName,
  awayName
} from '../observables/match'

const formatTime = (totalSeconds) => {
  const minutes = Math.floor(totalSeconds / 60)
  const seconds = totalSeconds - (minutes * 60)

  return [
    (minutes < 10 ? "0" + minutes : minutes),
    (seconds  < 10 ? "0" + seconds : seconds)
  ].join(':')
}

const preMatchComponent = ($el, match) => {
  secondsOld(match)
    .map((secondsOld) => Math.max(120 - secondsOld, 0))
    .map(formatTime)
    .assign($el.find('.pre-match-timer'), 'text')

  homeName(match).assign($el.find('.pre-match-player-name.home'), 'text')
  awayName(match).assign($el.find('.pre-match-player-name.away'), 'text')
}

export default preMatchComponent
