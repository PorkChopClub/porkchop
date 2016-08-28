import { h, Component } from 'preact'

import ScoreboardMatch from './ScoreboardMatch.js'

import { ongoingMatch } from '../api/matches'

class Scoreboard extends Component {
  componentDidMount() {
    ongoingMatch(this.props.tableId, 300)
      .subscribe((match) => this.setState({ ongoingMatch: match }))
  }

  render() {
    return <div>{this.currentView()}</div>
  }

  currentView() {
    if (this.state.ongoingMatch) {
      return (
        <ScoreboardMatch match={this.state.ongoingMatch}/>
      )
    } else {
      return (
        <h1>No match.</h1>
      )
    }
  }
}

export default Scoreboard
