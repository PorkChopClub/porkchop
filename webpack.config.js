"use strict";

var path = require('path');
var webpack = require('webpack');
var config = module.exports = {};

config.context = __dirname;

config.entry = {
  scoreboard: './app/webpack/scoreboard.js',
};

config.output = {
  path: path.join(__dirname, "app/assets/javascripts/entries"),
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
      loader: "babel-loader",
      query: {
        presets: ['es2015']
      }
    }
  ]
}

config.resolve = {
  // So we can do `require('./utils')` instead of `require('./utils.js')`
  extensions: ['', '.js']
};
