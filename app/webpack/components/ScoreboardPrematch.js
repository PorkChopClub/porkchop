import { h, Component } from 'preact'

import classNames from 'classnames'

export default ({ match, secondsRemaining }) => {
  const playersText = `${match['home-player'].name} versus ${match['away-player'].name}`
  const timeToPlay = secondsRemaining <= 0

  let countdownText
  if (secondsRemaining === 60) {
    countdownText = "1:00"
  } else if (secondsRemaining >= 70) {
    countdownText = `1:${secondsRemaining - 60}`
  } else if (secondsRemaining >= 60) {
    countdownText = `1:0${secondsRemaining - 60}`
  } else if (timeToPlay) {
    countdownText = "Time to play!!"
  } else if (secondsRemaining < 10) {
    countdownText = `0:0${secondsRemaining}`
  } else {
    countdownText = `0:${secondsRemaining}`
  }

  const classes = classNames({
    "scoreboard-prematch": true,
    "time-to-play": timeToPlay
  })

  return (
    <div className={classes}>
      <div className="scoreboard-prematch-text">
        <div className="scoreboard-prematch-players">{playersText}</div>
        <div className="scoreboard-prematch-countdown">{countdownText}</div>
      </div>
    </div>
  )
}
