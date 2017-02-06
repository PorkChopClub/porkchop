import { connect } from 'react-redux'

import { inactivePlayers } from '../../selectors/table'

const mapStateToProps = (state) => ({
  inactivePlayers: inactivePlayers(state)
})

const InactivePlayersList = (props) => {
  const { inactivePlayers } = props

  const players = inactivePlayers.map((player) => (
    <li key={player.id}>
      <button className="table-controls-button white">
        {player.name}
      </button>
    </li>
  ))

  return (
    <div>
      <h2 className="table-controls-player-list-heading">Not Playing</h2>
      <ul className="table-controls-player-list">
        {players}
      </ul>
    </div>
  )
}

export default connect(mapStateToProps)(InactivePlayersList)
