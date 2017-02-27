import classNames from 'classnames'

const classes = (player, match) => classNames(
  "ongoing-match-player",
  player,
  match[`${player}_service_state`]
)

const playerStyle = (player, match) => ({
  backgroundImage: `url(${match[`${player}_player`].portrait_url})`
})

export default ({ match }) => {
  const nextMatchPlayers = match.next_matchup.player_names.join(" vs ")

  return (
    <div className="scoreboard-ongoing-match scoreboard-page">
      <div className="ongoing-match-frame">
        <div className="ongoing-match-players">
          <div className={classes('home', match)}>
            <div className="portrait" style={playerStyle('home', match)}></div>
            <div className="name">{match.home_player.name}</div>
            <div className="score">{match.home_score}</div>
          </div>

          <div className={classes('away', match)}>
            <div className="portrait" style={playerStyle('away', match)}></div>
            <div className="name">{match.away_player.name}</div>
            <div className="score">{match.away_score}</div>
          </div>
        </div>

        <div className="ongoing-match-versus">vs</div>
      </div>

      <div className="ongoing-match-next-match">
        Next up: {nextMatchPlayers}
      </div>
    </div>
  )
}
