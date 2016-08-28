import { h, Component } from 'preact'

export default ({ match, secondsRemaining }) => {
  const playersText = `${match['home-player'].name} versus ${match['away-player'].name}`

  let countdownText
  if (secondsRemaining === 60) {
    countdownText = "1:00"
  } else if (secondsRemaining >= 70) {
    countdownText = `1:${secondsRemaining - 60}`
  } else if (secondsRemaining >= 60) {
    countdownText = `1:0${secondsRemaining - 60}`
  } else if (secondsRemaining <= 0) {
    countdownText = "Time to play!!"
  } else if (secondsRemaining < 10) {
    countdownText = `0:0${secondsRemaining}`
  } else {
    countdownText = `0:${secondsRemaining}`
  }

  return (
    <div className="scoreboard-prematch">
      <div className="scoreboard-prematch-text">
        <div className="scoreboard-prematch-players">{playersText}</div>
        <div className="scoreboard-prematch-countdown">{countdownText}</div>
      </div>
    </div>
  )
}
