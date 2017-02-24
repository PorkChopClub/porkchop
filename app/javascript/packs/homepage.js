import 'banner'

import Chart from 'chart.js'

$(() => {
  const canvas = $('.homepage-chart > .elo-chart')
  if (!canvas.length) { return }

  const colors = [
    'rgb(201,105,52)',
    'rgb(108,129,217)',
    'rgb(188,169,61)',
    'rgb(91,56,138)',
    'rgb(105,171,84)',
    'rgb(193,105,186)',
    'rgb(69,192,151)',
    'rgb(183,72,115)',
    'rgb(147,123,53)',
    'rgb(183,74,67)'
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
        pointHitRadius: 5
      }
    })
  }
  const options = {
    showTooltips: false,
    responsive: true
  }
  const ctx = canvas.get(0).getContext('2d')

  /* eslint-disable no-new */
  new Chart(ctx, {
    type: 'line',
    data: chartData,
    options
  })
})
