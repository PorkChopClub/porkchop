import { createSelector } from 'reselect'

export const ongoingMatch = (state) => state.ongoingMatch

export const secondsOld = createSelector(
  ongoingMatch,
  (ongoingMatch) => {
    if (!ongoingMatch) { return null; }
    return ongoingMatch.seconds_old
  }
)

export const isMatchHappening = createSelector(
  ongoingMatch,
  (ongoingMatch) => {
    return ongoingMatch !== null
  }
)

