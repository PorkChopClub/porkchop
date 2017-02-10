import { connect } from 'react-redux'

import { activePlayers } from '../../selectors/table'
import { deactivatePlayer } from '../../actions/table'

const mapStateToProps = (state) => ({
  activePlayers: activePlayers(state)
})

const mapDispatchToProps = (dispatch, { tableId }) => ({
  deactivatePlayer: (playerId) => () => dispatch(deactivatePlayer({ tableId, playerId }))
})

const ActivePlayersList = (props) => {
  const { activePlayers, deactivatePlayer } = props

  console.log(deactivatePlayer)
  const players = activePlayers.map((player) => (
    <li key={player.id}>
      <button className="table-controls-button blue" onClick={deactivatePlayer(player.id)}>
        {player.name}
      </button>
    </li>
  ))

  return (
    <div>
      <h2 className="table-controls-player-list-heading">Ready to Play</h2>
      <ul className="table-controls-player-list">
        {players}
      </ul>
    </div>
  )
}

export default connect(mapStateToProps, mapDispatchToProps)(ActivePlayersList)
