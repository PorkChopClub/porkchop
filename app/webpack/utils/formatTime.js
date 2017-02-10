// FIXME: This is very bad.
export default (timeInSeconds) => {
  const seconds = timeInSeconds % 60
  const formattedSeconds = seconds < 10 ? `0${seconds}` : `${seconds}`
  const formattedMinutes = timeInSeconds >= 60 ? '1' : '0'
  return [formattedMinutes, formattedSeconds].join(':')
}
