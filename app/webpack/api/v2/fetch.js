import { token } from '../../utils/csrf'

export default (path, options = {}) => {
  const defaultOptions = {
    credentials: 'same-origin',
    headers: { 'X-CSRF-Token': token() }
  }

  return fetch(path, { ...defaultOptions, ...options }).then((response) => response.json())
}
