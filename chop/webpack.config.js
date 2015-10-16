"use strict";

var ExtractTextPlugin = require("extract-text-webpack-plugin"),
    webpack = require("webpack");

var path = require("path");

function join(dest) { return path.resolve(__dirname, dest); }
function web(dest) { return join("web/static/" + dest); }

var sassOpts = [
  "?includePaths[]=", join("node_modules"),
  "&includePaths[]=", join("bower_components"),

  // fuck u bourbon
  "&includePaths[]=", join("node_modules/bourbon/app/assets/stylesheets")
].join("");

var config = module.exports = {
  entry: [
    web("css/pork.scss"),
    web("js/scoreboard.js")
  ],

  output: {
    path: join("priv/static"),
    filename: "js/scoreboard.js"
  },

  module: {
    loaders: [
      {
        test: /\.js$/,
        exclude: /node_modules/,
        loader: "babel?optional[]=runtime"
      },
      {
        test: /\.scss$/,
        loader: ExtractTextPlugin.extract("style", "css!sass" + sassOpts)
      }
    ]
  },

  plugins: [
    new ExtractTextPlugin("css/pork.css")
  ]
};

if (process.env.NODE_ENV === "production") {
  config.plugins.push(
    new webpack.optimize.DedupePlugin(),
    new webpack.optimize.UglifyJsPlugin({ minimize: true })
  );
}
