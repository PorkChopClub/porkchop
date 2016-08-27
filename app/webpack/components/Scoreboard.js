import { h, Component } from 'preact'

class Scoreboard extends Component {
  render() {
    return (
      <div>
        <h1>Scoreboard!</h1>
        <h2>Spectating table poo {this.props.tableId}</h2>
      </div>
    )
  }
}

export default Scoreboard
