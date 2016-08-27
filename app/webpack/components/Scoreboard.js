import { h, Component } from 'preact'

import { ongoingMatch } from '../api/matches'

class Scoreboard extends Component {
  componentDidMount() {
    ongoingMatch(this.props.tableId, 300)
      .subscribe((match) => this.setState({ ongoingMatch: match }))
  }

  render() {
    console.log(this.state.ongoingMatch)
    return (
      <div>
        <h1>Scoreboard! Time: {this.state.ongoingMatch}</h1>
        <h2>Spectating table {this.props.tableId}</h2>
      </div>
    )
  }
}

export default Scoreboard
