import { connect } from 'react-redux'

import formatTime from '../../utils/formatTime'

import {
  warmUpSecondsLeft,
  awayPlayerName,
  homePlayerName,
  spread
} from '../../selectors/ongoingMatch'

const mapStateToProps = (state) => {
  return {
    warmUpSecondsLeft: warmUpSecondsLeft(state),
    awayPlayerName: awayPlayerName(state),
    homePlayerName: homePlayerName(state),
    spread: spread(state)
  }
}

const MatchPreview = (props) => {
  const {
    awayPlayerName,
    homePlayerName,
    warmUpSecondsLeft,
    spread
  } = props
  return (
    <div className="scoreboard-pre-match scoreboard-page">
      <div className="pre-match-frame">
        <div className="pre-match-player-names">{homePlayerName} vs {awayPlayerName}</div>
        <div className="pre-match-spread">Favourite: {spread}</div>
        <div className="pre-match-timer">{formatTime(warmUpSecondsLeft)}</div>
      </div>
    </div>
  )
}

export default connect(mapStateToProps)(MatchPreview)
