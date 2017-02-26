import fetch from './fetch'

export const activePlayers = (tableId) => fetch(`/api/v2/tables/${tableId}/active_players`)

export const activatePlayer = ({ tableId, playerId }) => {
  return fetch(`/api/v2/tables/${tableId}/active_players`, {
    method: 'POST',
    body: JSON.stringify({ active_player: { id: playerId } })
  })
}

export const deactivatePlayer = ({ tableId, playerId }) => {
  return fetch(`/api/v2/tables/${tableId}/active_players/${playerId}`, {
    method: 'DELETE'
  })
}
