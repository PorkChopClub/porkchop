import 'banner'

import Chart from 'chart.js'

$(() => {
  const canvas = $('.player-elo-chart')
  if (!canvas.length) { return }

  const rawData = canvas.data('ratings')
  const chartData = {
    labels: $.map(rawData, () => ''),
    datasets: [
      {
        label: 'ELO',

        backgroundColor: 'rgba(34, 119, 255, 0.5)',
        borderColor: 'rgba(34, 119, 255, 1)',
        data: rawData,

        pointRadius: 0,
        pointHoverRadius: 20,
        pointHitRadius: 20
      }
    ]
  }
  const options = {
    legend: {
      display: false
    },
    scales: {
      xAxes: [{
        display: false
      }]
    }
  }
  const ctx = canvas.get(0).getContext('2d')

  /* eslint-disable no-new */
  new Chart(ctx, {
    type: 'line',
    data: chartData,
    options
  })
})
