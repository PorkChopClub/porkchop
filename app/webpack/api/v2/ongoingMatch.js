import { token } from '../../utils/csrf'

export const setup = (tableId) => {
  return fetch(
    `/api/v2/tables/${tableId}/matches/setup`,
    {
      method: 'POST',
      credentials: 'same-origin',
      headers: {
        'X-CSRF-Token': token()
      }
    }
  ).then((response) => response.json())
}
