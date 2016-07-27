import { updateMatch } from './matches'
import deserializeMatch from '../jsonApi/deserializeMatch'

export const trackTable = (tableId) => {
  return (dispatch) => {
    const matchPath = `/api/v2/tables/${tableId}/matches/ongoing`

    const fetchMatch = () => {
      fetch(matchPath)
        .then((response) => response.json())
        .then((json) => deserializeMatch(json))
        .then((match) => dispatch(updateMatch(match)))
        .then(() => setTimeout(fetchMatch, 500))
    }

    fetchMatch()
  }
}
