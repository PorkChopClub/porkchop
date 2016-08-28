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

  const avatarStyle = {
    "background-image": `url(${player['avatar-url']})`
  }

  return (
    <div className={classes}>
      <div className="scoreboard-player-avatar" style={avatarStyle}/>
      <div className="scoreboard-player-name">{displayName}</div>
      <div className="scoreboard-player-score">{score}</div>
    </div>
  )
}
