import $ from 'jquery'
import Chart from 'chart.js'

$(() => {
  const canvas = $('.homepage-chart > .elo-chart')
  if (!canvas.length) { return }

  const colors = [
    'rgba(255, 88, 88,1)',
    'rgba(255,163, 88,1)',
    'rgba( 83,241,241,1)',
    'rgba( 85,248, 85,1)',
    'rgba(255,154,154,1)',
    'rgba(255,200,154,1)',
    'rgba(148,244,244,1)',
    'rgba(151,250,151,1)',
    'rgba(255, 25, 25,1)',
    'rgba(255,129, 25,1)',
    'rgba( 23,240,240,1)',
    'rgba( 24,248, 24,1)',
    'rgba(255,  0,  0,1)',
    'rgba(255,116,  0,1)',
    'rgba(  0,238,238,1)',
    'rgba(  0,246,  0,1)',
  ]

  const rawData = canvas.data('ratings')
  const labels = canvas.data('labels')

  const players = Object.keys(rawData)
  if (!players.length) { return }

  const chartData = {
    labels: $.map(labels, (label, idx) => {
      if (idx % 7 === 0) { return label }
      return ''
    }),
    datasets: $.map(rawData, (_, player) => {
      const playerIndex = players.indexOf(player)
      const data = $.map(rawData[player], (_index, date) => rawData[player][date])
      return {
        data,
        label: player,
        fill: false,
        borderColor: colors[playerIndex],
        backgroundColor: colors[playerIndex],

        pointRadius: 0,
        pointHoverRadius: 5,
        pointHitRadius: 5,
      }
    }),
  }
  const options = {
    showTooltips: false,
    responsive: true,
  }
  const ctx = canvas.get(0).getContext('2d')

  /* eslint-disable no-new */
  new Chart(ctx, {
    type: 'line',
    data: chartData,
    options,
  })
})
