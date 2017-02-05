import { connect } from 'react-redux'

import {
  matchmake
} from '../../actions/table'

const mapStateToProps = (state) => {
  return {}
}

const mapDispatchToProps = (dispatch) => {
  return {
    onSetupClick: (tableId) => () => {
      dispatch(matchmake(tableId))
    }
  }
}

const TableControls = (props) => {
  const {
    tableId,
    onSetupClick
  } = props

  return (
    <div className="scoreboard-table-controls">
      <button className="table-controls-button green" onClick={onSetupClick(tableId)}>Setup match!</button>
    </div>
  )
}

export default connect(mapStateToProps, mapDispatchToProps)(TableControls)
