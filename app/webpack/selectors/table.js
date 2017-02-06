import { createSelector } from 'reselect'

export const table = (state) => state.table

export const isMatchmaking = createSelector(table, (table) => table.isMatchmaking)
export const tableId = createSelector(table, (table) => table.id)
export const trackingInterval = createSelector(table, (table) => table.trackingInterval)
export const activePlayers = createSelector(table, (table) => table.activePlayers)
