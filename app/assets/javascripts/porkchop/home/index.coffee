$ ->
  canvas = $(".homepage-chart > .elo-chart")
  return unless canvas.length

  colors = [
    "rgba(255, 88, 88,1)",
    "rgba(255,163, 88,1)",
    "rgba( 83,241,241,1)",
    "rgba( 85,248, 85,1)",
    "rgba(255,154,154,1)",
    "rgba(255,200,154,1)",
    "rgba(148,244,244,1)",
    "rgba(151,250,151,1)",
    "rgba(255, 25, 25,1)",
    "rgba(255,129, 25,1)",
    "rgba( 23,240,240,1)",
    "rgba( 24,248, 24,1)",
    "rgba(255,  0,  0,1)",
    "rgba(255,116,  0,1)",
    "rgba(  0,238,238,1)",
    "rgba(  0,246,  0,1)"
  ]

  rawData = canvas.data("ratings")
  labels = canvas.data("labels")

  players = Object.keys(rawData)
  return unless players.length

  chartData = {
    labels: $.map(labels, (label, idx)->
      if (idx % 7 == 0) then label else ""
    ),
    datasets: $.map(rawData, (_, player)->
      playerIndex = players.indexOf(player)
      {
        label: player,
        fillColor: "rgba(0,0,0,0)",
        strokeColor: colors[playerIndex],
        data: $.map(rawData[player], (_, date)->
          rawData[player][date]
        )
      }
    )
  }
  options = {
    showTooltips: false,
    scaleShowHorizontalLines: false,
    scaleShowVerticalLines: false,
    pointDot: false,
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
