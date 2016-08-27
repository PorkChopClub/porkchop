const checkStatus = (response) => {
  if (response.status >= 200 && response.status < 300) {
    return response
  } else {
    var error = new Error(response.statusText)
    error.response = response
    throw error
  }
}

const parseJSON = (response) => response.json()

const deserializeMatch = (json) => json

export const ongoingMatch = (tableId, interval) => {
  const callbacks = []
  const notifyCallbacks = (value) =>
    callbacks.forEach((callback) => callback(value))
  const handleSuccess = (value) => {
    refetchOngoingMatch()
    notifyCallbacks(value)
  }
  const handleFailure = (error) => {
    refetchOngoingMatch()
    if (error.response.status === 404) {
      callbacks.forEach((callback) => callback(null))
    } else {
      console.log('Failed to fetch ongoing match:', error)
    }
  }
  const refetchOngoingMatch = () => setTimeout(fetchOngoingMatch, interval)
  const fetchOngoingMatch = () =>
    fetch(`/api/v2/tables/${tableId}/matches/ongoing`)
      .then(checkStatus)
      .then(parseJSON)
      .then(deserializeMatch)
      .then(handleSuccess)
      .catch(handleFailure)

  fetchOngoingMatch()

  return { subscribe: (callback) => callbacks.push(callback) }
}
