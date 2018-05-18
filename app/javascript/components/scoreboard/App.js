import { connect } from 'react-redux'

import Scoreboard from './Scoreboard'
import TableControls from './TableControls'

import { tableId } from '../../selectors/table'

const mapStateToProps = (state) => ({
  tableId: tableId(state),
  connected: state.connection.connected
});

const NoConnection = () => (
  <div style={{
    backgroundColor: "#ff2461",
    position: "relative",
    width: 1920,
    height: 1080
  }}>
    <h1 style={{
      fontSize: 250,
      position: "absolute",
      top: "50%",
      left: "50%",
      transform: "translate(-50%, -50%)",
      color: "#ffffff",
      textAlign: "center"
    }}>CONNECTION BORKED</h1>
  </div>
)

const App = ({ tableId, connected }) => {
  const contents = connected ? [<Scoreboard/>, <TableControls tableId={tableId}/>] : <NoConnection />

  return (
    <div>{contents}</div>
  )
}

export default connect(mapStateToProps)(App)
