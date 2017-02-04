import { connect } from 'react-redux'

import OngoingMatch from './OngoingMatch'
import MatchPreview from './MatchPreview'
import MatchResult from './MatchResult'
import NoMatch from './NoMatch'

import { ongoingMatch, secondsOld, isMatchHappening } from '../../selectors/ongoingMatch'

const mapStateToProps = (state) => {
  return {
    isMatchHappening: isMatchHappening(state),
    secondsOld: secondsOld(state),
    ongoingMatch: ongoingMatch(state)
  }
}

const visibleComponent = (props) => {
  const {
    isMatchHappening,
    secondsOld,
    ongoingMatch
  } = props
  if (isMatchHappening) {
    if (secondsOld < 30) {
      return <MatchResult/>
    } else if (secondsOld < 90) {
      return <MatchPreview match={ongoingMatch}/>
    } else {
      return <OngoingMatch match={ongoingMatch}/>
    }
  } else {
    return <NoMatch/>
  }
}

const Scoreboard = (props) => {
  return (
    <div className="scoreboard">
      {visibleComponent(props)}
    </div>
  )
}

export default connect(mapStateToProps)(Scoreboard)
