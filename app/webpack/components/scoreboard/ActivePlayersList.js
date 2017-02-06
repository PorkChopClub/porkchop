import { connect } from 'react-redux'

import { activePlayers } from '../../selectors/table'

const mapStateToProps = (state) => ({
  activePlayers: activePlayers(state)
})

const ActivePlayersList = (props) => {
  const { activePlayers } = props

  const players = activePlayers.map((player) => (
    <li key={player.id}>
      <button className="table-controls-button blue">
        {player.name}
      </button>
    </li>
  ))

  return (
    <div>
      <h2 className="table-controls-player-list-heading">Active Players</h2>
      <ul className="table-controls-player-list">
        {players}
      </ul>
    </div>
  )
}

export default connect(mapStateToProps)(ActivePlayersList)
