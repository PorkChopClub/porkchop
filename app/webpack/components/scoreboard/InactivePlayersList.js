import { connect } from 'react-redux'

import { inactivePlayers } from '../../selectors/table'

import { activatePlayer } from '../../actions/table'

const mapStateToProps = (state) => {
  const players = inactivePlayers(state)
  const retiredPlayers = players.filter(({ isRetired }) => isRetired)
  const unretiredPlayers = players.filter(({ isRetired }) => !isRetired)

  return { retiredPlayers, unretiredPlayers }
}

const mapDispatchToProps = (dispatch, { tableId }) => ({
  activatePlayer: (playerId) => () => dispatch(activatePlayer({ tableId, playerId }))
})

const InactivePlayersList = (props) => {
  const { retiredPlayers, unretiredPlayers, activatePlayer } = props

  const retiredPlayerListItems = retiredPlayers.map((player) => {
    return (
      <li key={player.id}>
        <button className="table-controls-button grey small" onClick={activatePlayer(player.id)}>
          {player.name}
        </button>
      </li>
    )
  })

  const unretiredPlayerListItems = unretiredPlayers.map((player) => (
    <li key={player.id}>
      <button className="table-controls-button white" onClick={activatePlayer(player.id)}>
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

export default connect(mapStateToProps, mapDispatchToProps)(InactivePlayersList)
