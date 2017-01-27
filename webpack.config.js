module.exports = function(options) {
  var path = require('path');
  var webpack = require('webpack');
  var config = {};

  config.context = __dirname;

  const entry = (name) => [
    "jquery-ujs",
    "babel-polyfill",
    `./app/webpack/${name}.js`
  ]

  config.entry = {
    default: entry('default'),
    homepage: entry('homepage'),
    player_show: entry('playerShow'),
    scoreboard: entry('scoreboard')
  };

  config.output = {
    path: path.join(__dirname, "app/assets/javascripts"),
    filename: "[name].js"
  }

  config.plugins = [
    new webpack.ProvidePlugin({
      fetch: 'imports-loader?this=>global!exports-loader?global.fetch!whatwg-fetch',
      jQuery: 'jquery',
      $: 'jquery'
    })
  ];

  config.module = {
    loaders: [
      { test: /\.js$/,
        exclude: /node_modules/,
        loader: "babel-loader"
      }
    ]
  }

  return config;
};
