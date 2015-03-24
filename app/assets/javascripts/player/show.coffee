#= require Chart

$ ->
  canvas = $(".player-elo-chart")
  return unless canvas.length

  rawData = canvas.data("ratings")
  chartData = {
    labels: $.map(rawData, -> ""),
    datasets: [
      {
        fillColor: "rgba(153,134,142,0.2)",
        strokeColor: "rgba(153,134,142,1)",
        pointColor: "rgba(153,134,142,1)",
        pointStrokeColor: "#fff",
        pointHighlightFill: "#fff",
        pointHighlightStroke: "rgba(153,134,142,1)",
        data: rawData
      }
    ]
  }
  options = {
    showTooltips: false,
    scaleShowHorizontalLines: false,
    scaleShowVerticalLines: false,
    pointDot: false
  }
  ctx = canvas.get(0).getContext("2d")
  new Chart(ctx).Line(chartData, options)
