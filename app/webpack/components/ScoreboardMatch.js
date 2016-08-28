import { h, Component } from 'preact'

import ScoreboardPlayer from './ScoreboardPlayer'

export default ({ match }) => {
  console.log(match)
  return (
    <div>
      <ScoreboardPlayer
        player={match['home-player']}
        hasService={match['home-service']}
        score={match['home-score']}/>
      <ScoreboardPlayer
        player={match['away-player']}
        hasService={match['away-service']}
        score={match['away-score']}/>
    </div>
  )
}
