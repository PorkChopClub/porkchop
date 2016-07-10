import $ from 'jquery'
import { h, render } from 'preact'

import './shared'
import header from './components/header'
import './components/player_elo_chart'
import './components/homepage_elo_chart'
import './components/player_activations'
import './components/match_controls'

$(() => {
  header($('.main-navigation'))
  render((
    <div id="foo">
      <span>Hello, world!</span>
      <button onClick={ e => alert("hi!") }>Click Me</button>
    </div>
  ), document.body);
});

