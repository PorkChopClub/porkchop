/* eslint no-else-return: "off" */
export default function(endpoint) {
  if (process.env.NODE_ENV === 'production') {
    // API requests should hit heroku directly in prod, avoiding Cloudfront
    return `https://porkchop-prod.herokuapp.com/api/${endpoint}`
  } else {
    return `/api/${endpoint}`
  }
}
