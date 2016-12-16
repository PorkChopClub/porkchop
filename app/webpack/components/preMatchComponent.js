import { secondsOld } from '../observables/match'

const preMatchComponent = ($el, match) => {
  secondsOld(match)
    .map((secondsOld) => 120 - secondsOld)
    .assign($el.find('.pre-match-timer'), 'text')
}

export default preMatchComponent
