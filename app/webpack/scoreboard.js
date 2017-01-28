import './banner'

import { render } from 'react-dom'

render(
  <div className="scoreboard">
    <div className="scoreboard-ongoing-match scoreboard-page">
      <div className="ongoing-match-players">
        <div className="ongoing-match-player home">
          <div className="portrait"></div>
          <div className="name"></div>
          <div className="score"></div>
        </div>

        <div className="ongoing-match-player away">
          <div className="portrait"></div>
          <div className="name"></div>
          <div className="score"></div>
        </div>
      </div>

      <div className="ongoing-match-versus">vs</div>
    </div>

    <div className="scoreboard-pre-match scoreboard-page">
      <div className="pre-match-timer"></div>
      <div className="pre-match-player-name home"></div>
      <div className="pre-match-player-name away"></div>
    </div>

    <div className="scoreboard-post-match scoreboard-page">
      <h1>Post match.</h1>
    </div>

    <div className="scoreboard-no-match scoreboard-page">
      <h1>No match.</h1>
    </div>
  </div>,
  document.getElementById('scoreboard')
)
