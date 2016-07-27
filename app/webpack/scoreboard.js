import './shared'

import { h, render } from 'preact'
import Scoreboard from './components/Scoreboard'

const scoreboard = document.getElementById('scoreboard')

render(
  <Scoreboard />,
  scoreboard
)
