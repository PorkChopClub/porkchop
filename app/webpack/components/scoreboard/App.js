import Scoreboard from './Scoreboard'
import TableControls from './TableControls'

export default ({ tableId }) => (
  <div>
    <Scoreboard/>
    <TableControls tableId={tableId}/>
  </div>
)
