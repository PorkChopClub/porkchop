import { interval } from 'baconjs';

const matchField = (field) =>
  (match) =>
    match
      .filter((match) => !!match)
      .map(field)
      .skipDuplicates()

export const secondsOld = (match) => {
  const lastAge =
    match
      .filter((match) => !!match)
      .map('.seconds_old')
      .map((n) => ({ type: 'RESET', payload: n }))

  const counter =
    interval(1000, 1)
      .map((n) => ({ type: 'INCREMENT', payload: n }))

  return counter
    .merge(lastAge)
    .scan(0, (count, event) => {
      if (event.type === 'RESET') {
        return event.payload
      } else {
        return count + event.payload
      }
    })
};
  
// matchField('.seconds_old')

export const homeScore = matchField('.home_score')
export const awayScore = matchField('.away_score')

export const homeName = matchField('.home_player.name')
export const awayName = matchField('.away_player.name')

export const homePortrait = matchField('.home_player.portrait_url')
export const awayPortrait = matchField('.away_player.portrait_url')

const serviceState = (field) =>
  (match) => matchField(field)(match).map((value) => {
    switch (value) {
      case true:
        return 'serving'
      case false:
        return 'receiving'
      default:
        return 'no-service'
    }
  })

export const homeServiceState = serviceState('.home_service')
export const awayServiceState = serviceState('.away_service')
