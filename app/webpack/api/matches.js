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

const deserializeMatch = (json) => {
  let resources = [json.data].concat(json.included)

  resources = resources.map((resource) => {
    Object.assign(resource, resource.attributes)
    delete resource.attributes


    if (resource.relationships) {
      for (let relationshipName in resource.relationships) {
        const relationship = resource.relationships[relationshipName].data

        if (Array.isArray(relationship)) {
          const relatedResources = relationship.map((relationship) => {
            return resources.find((resource) => {
              return resource.id === relationship.id && resource.type === relationship.type
            })
          })
          resource[relationshipName] = relatedResources
        } else {
          const relatedResource = resources.find((resource) => {
            return resource.id === relationship.id && resource.type === relationship.type
          })
          resource[relationshipName] = relatedResource
        }
      }

      delete resource.relationships
    }

    return resource
  })

  return resources[0]
}

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
