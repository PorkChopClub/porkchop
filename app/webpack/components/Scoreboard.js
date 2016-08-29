import { h, Component } from 'preact'

import ScoreboardMatch from './ScoreboardMatch.js'
import ScoreboardPrematch from './ScoreboardPrematch.js'
import ScoreboardNoMatch from './ScoreboardNoMatch.js'
import ScoreboardFinishedMatch from './ScoreboardFinishedMatch.js'

import { ongoingMatch } from '../api/matches'

class Scoreboard extends Component {
  componentDidMount() {
    ongoingMatch(this.props.tableId, 300)
      .subscribe((match) => {
        this.setState((previousState) => {
          const newState = { ...previousState }
          if (match && (!newState.ongoingMatch || newState.ongoingMatch.id !== match.id)) {
            newState.matchStart = Date.now() / 1000
          }
          newState.ongoingMatch = match
          return newState
        })
      })
  }

  currentView() {
    if (this.state.ongoingMatch) {
      if (this.state.ongoingMatch['finished?']) {
        return <ScoreboardFinishedMatch match={this.state.ongoingMatch} />
      } else if (this.state.ongoingMatch['service-selected']) {
        return <ScoreboardMatch match={this.state.ongoingMatch} />
      } else {
        return (
          <ScoreboardPrematch
            match={this.state.ongoingMatch}
            secondsRemaining={this.secondsRemaining()}
          />
        )
      }
    } else {
      return <ScoreboardNoMatch />
    }
  }

  secondsRemaining() {
    const now = (Date.now() / 1000)
    return Math.round(this.state.matchStart + 90 - now)
  }

  render() {
    return <div>{this.currentView()}</div>
  }
}

export default Scoreboard
