import { token } from '../../utils/csrf'

export default (path, options = {}) => {
  const defaultOptions = {
    credentials: 'same-origin',
    headers: { 'X-CSRF-Token': token() }
  }

  const jsonPromise =
    fetch(path, { ...defaultOptions, ...options })
      .then((response) => response.json())

  return jsonPromise
}
