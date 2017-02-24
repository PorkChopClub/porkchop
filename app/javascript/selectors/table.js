import { createSelector } from 'reselect'

import players from './players'

export const table = (state) => state.table

export const isMatchmaking = createSelector(table, (table) => table.isMatchmaking)
export const tableId = createSelector(table, (table) => table.id)
export const trackingInterval = createSelector(table, (table) => table.trackingInterval)
export const activePlayers = createSelector(table, (table) => table.activePlayers)

export const inactivePlayers = createSelector(
  activePlayers, players,
  (activePlayers, players) => {
    const activePlayerIds = activePlayers.map(({ id }) => id)
    return players.filter((player) => !activePlayerIds.includes(player.id))
  }
)
