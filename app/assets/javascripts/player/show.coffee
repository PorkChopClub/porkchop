#= require Chart

$ ->
  canvas = $(".player-elo-chart")
  return unless canvas.length

  rawData = canvas.data("ratings")
  chartData = {
    labels: $.map(rawData, -> ""),
    datasets: [
      {
        fillColor: "rgba(53,46,55,0.2)",
        strokeColor: "rgba(53,46,55,1)",
        pointColor: "rgba(53,46,55,1)",
        pointStrokeColor: "#fff",
        pointHighlightFill: "#fff",
        pointHighlightStroke: "rgba(53,46,55,1)",
        data: rawData
      }
    ]
  }
  ctx = canvas.get(0).getContext("2d")
  new Chart(ctx).Line(chartData)
