export default (props) => (
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
)
