module.exports = function(options) {
  var path = require('path');
  var webpack = require('webpack');
  var config = {};

  config.context = __dirname;

  config.entry = {
    scoreboard: './app/webpack/scoreboard.js',
    default: './app/webpack/default.js'
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

  if (process.env.NODE_ENV === "production") {
    config.plugins.push(
      new webpack.DefinePlugin({
        'process.env': { 'NODE_ENV': JSON.stringify('production') }
      })
    );
  }

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
