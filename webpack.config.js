"use strict";

var path = require('path');
var webpack = require('webpack');
var config = module.exports = {};

config.context = __dirname;

config.entry = {
  scoreboard: './app/webpack/scoreboard.js',
  default: './app/webpack/default.js'
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
  extensions: ['', '.js'],
  root: [path.join(__dirname, "app/webpack")]
};
