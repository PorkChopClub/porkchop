import { connect } from 'react-redux'

import { activePlayers } from '../../selectors/table'

const mapStateToProps = (state) => ({
  activePlayers: activePlayers(state)
})

const ActivePlayersList = (props) => {
  const { activePlayers } = props

  const players = activePlayers.map((player) => (
    <li key={player.id}>
      {player.name}
    </li>
  ))

  return (
    <ul>
      {players}
    </ul>
  )
}

export default connect(mapStateToProps)(ActivePlayersList)
