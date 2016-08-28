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
        fillColor: 'rgba(153,134,142,0.2)',
        strokeColor: 'rgba(153,134,142,1)',
        pointColor: 'rgba(153,134,142,1)',
        pointStrokeColor: '#fff',
        pointHighlightFill: '#fff',
        pointHighlightStroke: 'rgba(153,134,142,1)',
        data: rawData,
      },
    ],
  }
  const options = {
    showTooltips: false,
    scaleShowHorizontalLines: false,
    scaleShowVerticalLines: false,
    pointDot: false,
    responsive: true,
  }
  const ctx = canvas.get(0).getContext('2d')
  new Chart(ctx).Line(chartData, options)
})
