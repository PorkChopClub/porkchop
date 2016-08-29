import { h } from 'preact'
import classNames from 'classnames'

export default ({ player, score, hasService }) => {
  const displayName = player.nickname || player.name
  const longName = displayName.length >= 24

  const componentClasses = classNames({
    'scoreboard-player': true,
    'has-service': hasService !== false,
    'long-name': longName
  })

  const avatarStyle = {
    'background-image': `url(${player['avatar-url']})`
  }

  return (
    <div className={componentClasses}>
      <div className="scoreboard-player-avatar" style={avatarStyle} />
      <div className="scoreboard-player-name">
        <div className="scoreboard-player-name-text">{displayName}</div>
      </div>
      <div className="scoreboard-player-score">{score}</div>
    </div>
  )
}
