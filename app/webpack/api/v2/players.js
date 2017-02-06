import fetch from './fetch'

export const players = () => fetch(`/api/v2/players`)
