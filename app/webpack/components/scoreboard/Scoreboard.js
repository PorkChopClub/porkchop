import { connect } from 'react-redux'

import OngoingMatch from './OngoingMatch'
import MatchPreview from './MatchPreview'
import MatchResult from './MatchResult'
import NoMatch from './NoMatch'

const mapStateToProps = ({ ongoingMatch }) => {
  return {
    isGameHappening: !!ongoingMatch,
    ongoingMatch,
  }
}

const visibleComponent = ({ isGameHappening, ongoingMatch }) => {
  if (isGameHappening) {
    const { secondsOld } = ongoingMatch;
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
