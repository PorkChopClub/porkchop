/* FIXME: This will likely turn into a general method for deserializing all our
 * JSON-API responses, but for now I'm implementing it on a
 * resource-by-resource basis to figure out what we need.
 */
export default ({ data }) => ({ ...data.attributes, id: data.id })
