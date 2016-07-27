import { h, Component } from 'preact'
import { connect } from 'preact-redux'

const mapState = (state) => {
  const tableId = state.scoreboard.tableId
  for (var match of state.matches.values()) {
    console.log(match)
  }
  return { tableId, match }
}

const Scoreboard = ({ tableId, match }) => {
  return (
    <div>
      <h1>Scoreboard!</h1>
      <h2>Spectating table {tableId}</h2>
    </div>
  )
}

export default connect(mapState)(Scoreboard)
