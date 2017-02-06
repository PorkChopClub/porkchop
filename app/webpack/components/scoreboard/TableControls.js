import { connect } from 'react-redux'

import ActivePlayersList from './ActivePlayersList'
import InactivePlayersList from './InactivePlayersList'

import {
  matchmake
} from '../../actions/table'

import {
  isMatchmaking
} from '../../selectors/table'

const mapStateToProps = (state) => {
  return {
    isMatchmaking: isMatchmaking(state),
  }
}

const mapDispatchToProps = (dispatch, { tableId }) => {
  return {
    onSetupClick: () => dispatch(matchmake(tableId))
  }
}

const TableControls = (props) => {
  const { onSetupClick } = props

  return (
    <div className="scoreboard-table-controls">
      <button className="table-controls-button green" onClick={onSetupClick}>
        Setup match!
      </button>
      <ActivePlayersList/>
      <InactivePlayersList/>
    </div>
  )
}

export default connect(mapStateToProps, mapDispatchToProps)(TableControls)
