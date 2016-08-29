import { h } from 'preact'

export default ({ match }) => {
  let winner
  let loser
  let winnerScore
  let loserScore

  if (match['home-score'] > match['away-score']) {
    winner = match['home-player'].name
    loser = match['away-player'].name
    winnerScore = match['home-score']
    loserScore = match['away-score']
  } else {
    winner = match['away-player'].name
    loser = match['home-player'].name
    winnerScore = match['away-score']
    loserScore = match['home-score']
  }

  return (
    <div className="scoreboard-finished-match">
      <div className="scoreboard-finished-match-text">
        {winner}
        <br />
        defeated
        <br />
        {loser}
        <br />
        {winnerScore} to {loserScore}
      </div>
    </div>
  )
}
