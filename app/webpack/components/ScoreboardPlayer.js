import { h, Component } from 'preact'
import classNames from 'classnames'

export default ({ player, score, hasService }) => {
  console.log(player)
  const displayName = player.nickname || player.name
  const longName = displayName.length >= 24

  const classes = classNames({
    "scoreboard-player": true,
    "has-service": hasService === false,
    "long-name": longName
  })

  return (
    <div className={classes}>
      <div className="scoreboard-player-name">{displayName}</div>
      <div>{score}</div>
    </div>
  )
}