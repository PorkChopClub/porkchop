#= require Chart

$ ->
  canvas = $(".homepage-chart > .elo-chart")
  return unless canvas.length

  colors = [
    "153,134,142",
    "123,100,110",
    " 89, 66, 76",
    "179,161,157",
    "144,122,118",
    "105, 82, 78",
    "114,130,120",
    "190,196,192",
    "147,159,151",
    " 85,105, 93",
    " 56, 76, 64",
    "155,164,143",
    "193,200,185",
    "121,132,107",
    " 85, 96, 71",
  ]

  rawData = canvas.data("ratings")
  players = Object.keys(rawData)
  return unless players.length

  chartData = {
    labels: canvas.data("labels"),
    datasets: $.map(rawData, (_, player)->
      playerIndex = players.indexOf(player)
      {
        label: player,
        fillColor: "rgba(#{colors[playerIndex]},0.2)",
        strokeColor: "rgba(#{colors[playerIndex]},1)",
        pointColor: "rgba(#{colors[playerIndex]},1)",
        pointStrokeColor: "#fff",
        pointHighlightFill: "#fff",
        pointHighlightStroke: "rgba(#{colors[playerIndex]},1)",
        data: $.map(rawData[player], (_, date)->
          rawData[player][date]
        )
      }
    )
  }
  options = {
    scaleShowHorizontalLines: false,
    scaleShowVerticalLines: false,
    legendTemplate : "<ul class=\"elo-legend\">" +
      "<% for (var i=0; i<datasets.length; i++){ %>" +
        "<li>" +
          "<span class=\"swatch\" style=\"background-color:<%= datasets[i].strokeColor %>\"></span>" +
          "<% if(datasets[i].label) { %>" +
            "<%= datasets[i].label %>" +
          "<% } %>" +
        "</li>" +
      "<% } %>" +
    "</ul>"
  }
  ctx = canvas.get(0).getContext("2d")
  chart = new Chart(ctx).Line(chartData, options)
  canvas.after(chart.generateLegend())
