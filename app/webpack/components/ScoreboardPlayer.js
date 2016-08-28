import { h, Component } from 'preact'
import classNames from 'classnames'

export default ({ player, score, hasService }) => {
  const classes = classNames({
    "scoreboard-player": true,
    "has-service": hasService === false
  })

  return (
    <div className={classes}>
      <div className="scoreboard-player-name">{player.nickname || player.name}</div>
      <div>{score}</div>
    </div>
  )
}
