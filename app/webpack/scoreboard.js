import { h, render } from 'preact'

import Scoreboard from './components/Scoreboard'

const tableId = document.body.dataset.tableId
render(<Scoreboard tableId={tableId}/>, document.body)
