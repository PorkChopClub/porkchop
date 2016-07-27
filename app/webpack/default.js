import { h, render } from 'preact'

import './shared'
import './components/player_elo_chart'
import './components/homepage_elo_chart'
import './components/player_activations'
import './components/match_controls'

import Header from './components/Header'

const header = document.getElementById('main-navigation')

render(
  <Header
    loggedIn={header.dataset.loggedIn === 'true'}
    showControls={header.dataset.showControls === 'true'}
  />,
  header
)
