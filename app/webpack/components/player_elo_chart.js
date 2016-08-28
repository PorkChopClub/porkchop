import $ from 'jquery'
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

        backgroundColor: 'rgba(153,134,142,0.2)',
        borderColor: 'rgba(153,134,142,1)',
        data: rawData,

        pointRadius: 0,
        pointHoverRadius: 10,
        pointHitRadius: 10,
      },
    ],
  }
  const options = {
    legend: {
      display: false,
    },
    scales: {
      xAxes: [{
        display: false,
      }],
    },
  }
  const ctx = canvas.get(0).getContext('2d')

  /* eslint-disable no-new */
  new Chart(ctx, {
    type: 'line',
    data: chartData,
    options,
  })
})
