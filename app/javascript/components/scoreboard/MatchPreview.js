import { connect } from 'react-redux'

import formatTime from '../../utils/formatTime'

import {
  warmUpSecondsLeft,
  awayPlayerName,
  homePlayerName
} from '../../selectors/ongoingMatch'

const mapStateToProps = (state) => {
  return {
    warmUpSecondsLeft: warmUpSecondsLeft(state),
    awayPlayerName: awayPlayerName(state),
    homePlayerName: homePlayerName(state)
  }
}

const MatchPreview = (props) => {
  const {
    awayPlayerName,
    homePlayerName,
    warmUpSecondsLeft
  } = props
  return (
    <div className="scoreboard-pre-match scoreboard-page">
      <div className="pre-match-timer">{formatTime(warmUpSecondsLeft)}</div>
      <div className="pre-match-player-name home">{homePlayerName}</div>
      <div className="pre-match-player-name away">{awayPlayerName}</div>
    </div>
  )
}

export default connect(mapStateToProps)(MatchPreview)
