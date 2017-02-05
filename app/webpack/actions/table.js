import { createAction } from 'redux-actions'

import { setup } from '../api/v2/ongoingMatch'

export const setTableId = createAction('TABLE_SET_ID')

export const startMatchSetup = createAction('TABLE_MATCH_SETUP_START')
export const finishMatchSetup = createAction('TABLE_MATCH_SETUP_FINISH')

export const matchmake = (tableId) => (dispatch, getState) => {
  dispatch(startMatchSetup())
  setup(tableId).then((json) => {
    console.log(json);
    dispatch(finishMatchSetup())
  })
}
