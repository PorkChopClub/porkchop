import fetch from './fetch'

export const setup = (tableId) => fetch(`/api/v2/tables/${tableId}/matches/setup`, { method: 'POST', })
