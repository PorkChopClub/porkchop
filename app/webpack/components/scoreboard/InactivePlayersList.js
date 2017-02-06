import { connect } from 'react-redux'

import { inactivePlayers } from '../../selectors/table'

const mapStateToProps = (state) => {
  const players = inactivePlayers(state)
  const retiredPlayers = players.filter(({ isRetired }) => isRetired)
  const unretiredPlayers = players.filter(({ isRetired }) => !isRetired)

  return { retiredPlayers, unretiredPlayers }
}

const InactivePlayersList = (props) => {
  const { retiredPlayers, unretiredPlayers } = props

  const retiredPlayerListItems = retiredPlayers.map((player) => (
    <li key={player.id}>
      <button className="table-controls-button grey small">
        {player.name}
      </button>
    </li>
  ))

  const unretiredPlayerListItems = unretiredPlayers.map((player) => (
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
        {unretiredPlayerListItems}
      </ul>
      <ul className="table-controls-player-list">
        {retiredPlayerListItems}
      </ul>
    </div>
  )
}

export default connect(mapStateToProps)(InactivePlayersList)
