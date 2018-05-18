import { connect } from 'react-redux'

import OngoingMatch from './OngoingMatch'
import MatchPreview from './MatchPreview'
import MatchResult from './MatchResult'
import NoMatch from './NoMatch'

import {
  ongoingMatch,
  secondsOld,
  isMatchHappening,
  isMatchStarted
} from '../../selectors/ongoingMatch'

const mapStateToProps = (state) => {
  return {
    isMatchHappening: isMatchHappening(state),
    secondsOld: secondsOld(state),
    ongoingMatch: ongoingMatch(state),
    isMatchStarted: isMatchStarted(state)
  }
}

const visibleComponent = (props) => {
  const {
    isMatchHappening,
    secondsOld,
    ongoingMatch,
    isMatchStarted
  } = props
  if (!isMatchHappening) { return <NoMatch/> }

  if (!isMatchStarted && secondsOld < 90) {
    return <MatchPreview/>
  }

  return <OngoingMatch match={ongoingMatch}/>
}

const Scoreboard = (props) =>  (
  <div className="scoreboard">
    {visibleComponent(props)}
  </div>
)

export default connect(mapStateToProps)(Scoreboard)
