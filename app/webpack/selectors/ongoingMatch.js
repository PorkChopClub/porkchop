import { createSelector } from 'reselect'

export const ongoingMatch = (state) => state.ongoingMatch

export const secondsOld = createSelector(
  ongoingMatch,
  (ongoingMatch) => {
    if (!ongoingMatch) { return null; }
    return ongoingMatch.seconds_old
  }
)

export const warmUpSecondsLeft = createSelector(
  secondsOld,
  (secondsOld) => Math.max(90 - secondsOld, 0)
)

export const isMatchHappening = createSelector(
  ongoingMatch,
  (ongoingMatch) => {
    return ongoingMatch !== null
  }
)

export const homePlayer = createSelector(
  ongoingMatch,
  (ongoingMatch) => {
    return ongoingMatch ? ongoingMatch.home_player : null
  }
)

export const homePlayerName = createSelector(
  homePlayer,
  (homePlayer) => {
    return homePlayer ? homePlayer.name : null
  }
)

export const awayPlayer = createSelector(
  ongoingMatch,
  (ongoingMatch) => {
    return ongoingMatch ? ongoingMatch.away_player : null
  }
)

export const awayPlayerName = createSelector(
  awayPlayer,
  (awayPlayer) => {
    return awayPlayer ? awayPlayer.name : null
  }
)
