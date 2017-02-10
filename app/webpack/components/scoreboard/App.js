import { connect } from 'react-redux'

import Scoreboard from './Scoreboard'
import TableControls from './TableControls'

import { tableId } from '../../selectors/table'

const mapStateToProps = (state) => ({
  tableId: tableId(state)
});

const App = ({ tableId }) => (
  <div>
    <Scoreboard/>
    <TableControls tableId={tableId}/>
  </div>
)

export default connect(mapStateToProps)(App)
