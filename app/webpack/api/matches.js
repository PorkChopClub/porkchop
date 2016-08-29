const checkStatus = (response) => {
  if (response.status >= 200 && response.status < 300) {
    return response
  } else {
    const error = new Error(response.statusText)
    error.response = response
    throw error
  }
}

const parseJSON = (response) => response.json()

/* eslint-disable no-param-reassign */
const deserializeMatch = (json) => {
  if (!json.data) { return undefined }

  let resources = [json.data].concat(json.included)

  resources = resources.map((resource) => {
    Object.assign(resource, resource.attributes)
    delete resource.attributes

    if (resource.relationships) {
      // eslint-disable-next-line no-restricted-syntax
      for (const relationshipName in resource.relationships) {
        if ({}.hasOwnProperty.call(resource.relationships, relationshipName)) {
          const relationship = resource.relationships[relationshipName].data

          if (Array.isArray(relationship)) {
            const relatedResources = relationship.map((rel) =>
              resources.find((res) => res.id === rel.id && res.type === rel.type))
            resource[relationshipName] = relatedResources
          } else {
            const relatedResource = resources.find((res) =>
              res.id === relationship.id && res.type === relationship.type)
            resource[relationshipName] = relatedResource
          }
        }
      }

      delete resource.relationships
    }

    return resource
  })

  return resources[0]
}
/* eslint-enable no-param-reassign */

export const ongoingMatch = (tableId, interval) => {
  const callbacks = []
  const notifyCallbacks = (value) =>
    callbacks.forEach((callback) => callback(value))
  const handleSuccess = (value) => {
    // eslint-disable-next-line no-use-before-define
    refetchOngoingMatch()
    notifyCallbacks(value)
  }
  const handleFailure = (error) => {
    // eslint-disable-next-line no-use-before-define
    refetchOngoingMatch()
    throw error
  }
  const fetchOngoingMatch = () =>
    fetch(`/api/v2/tables/${tableId}/matches/ongoing`)
      .then(checkStatus)
      .then(parseJSON)
      .then(deserializeMatch)
      .then(handleSuccess)
      .catch(handleFailure)
  const refetchOngoingMatch = () => setTimeout(fetchOngoingMatch, interval)

  fetchOngoingMatch()

  return { subscribe: (callback) => callbacks.push(callback) }
}
