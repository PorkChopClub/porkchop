module.exports = function(options) {
  var path = require('path');
  var webpack = require('webpack');
  var config = {};

  config.context = __dirname;

  const entry = (name) => [
    "babel-polyfill",
    "./app/webpack/shared.js",
    `./app/webpack/${name}.js`
  ]

  config.entry = {
    scoreboard: entry('scoreboard'),
    default: entry('default')
  };

  config.output = {
    path: path.join(__dirname, "app/assets/javascripts"),
    filename: "[name].js"
  }

  config.plugins = [
    new webpack.ProvidePlugin({
      'fetch': 'imports?this=>global!exports?global.fetch!whatwg-fetch'
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

  config.resolve = {
    root: path.resolve(__dirname, "./app/webpack")
  };

  return config;
};
