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
    return <OngoingMatch match={ongoingMatch}/>
  } else {
    return <NoMatch/>
  }
}
// FIXME: Display these too.
// <MatchPreview/>
// <MatchResult/>

const Scoreboard = (props) => {
  return (
    <div className="scoreboard">
      {visibleComponent(props)}
    </div>
  )
}

export default connect(mapStateToProps)(Scoreboard)
