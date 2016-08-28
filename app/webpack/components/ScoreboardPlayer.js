import { h, Component } from 'preact'

export default ({ player, score, hasService }) => {
  return (
    <div>
      <h1>{player.name}</h1>
      <div>{score}</div>
    </div>
  )
}
