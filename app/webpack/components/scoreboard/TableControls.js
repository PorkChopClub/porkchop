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
    <div>
      <h1>Table Controls</h1>
      <button onClick={onSetupClick(tableId)}>Test</button>
    </div>
  )
}

export default connect(mapStateToProps, mapDispatchToProps)(TableControls)
