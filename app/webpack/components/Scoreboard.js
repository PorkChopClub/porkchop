import { h, Component } from 'preact'

import ScoreboardMatch from './ScoreboardMatch.js'
import ScoreboardPrematch from './ScoreboardPrematch.js'

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

  render() {
    return <div>{this.currentView()}</div>
  }

  currentView() {
    if (this.state.ongoingMatch) {
      if (this.matchStarted()) {
        return <ScoreboardMatch match={this.state.ongoingMatch}/>
      } else {
        return (
          <ScoreboardPrematch
            match={this.state.ongoingMatch}
            secondsRemaining={this.secondsRemaining()}/>
        )
      }
    } else {
      return (
        <h1>No match.</h1>
      )
    }
  }

  secondsRemaining() {
    const now = (Date.now() / 1000)
    return Math.round(this.state.matchStart + 90 - now)
  }

  matchStarted() {
    return false //this.state.ongoingMatch
  }
}

export default Scoreboard
