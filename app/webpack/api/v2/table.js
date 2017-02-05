import fetch from './fetch'

export const activePlayers = (tableId) => fetch(`/api/v2/tables/${tableId}/active_players`)
