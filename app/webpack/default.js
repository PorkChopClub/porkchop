import $ from 'jquery'

import './shared'
import header from './components/header'
import './components/player_elo_chart'
import './components/homepage_elo_chart'
import './components/player_activations'
import './components/match_controls'

$(() => {
  header($('.main-navigation'))
});

