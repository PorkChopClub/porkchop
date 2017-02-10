export const token = () => {
  const meta = document.querySelector('meta[name=csrf-token]')
  return meta && meta.content
}
