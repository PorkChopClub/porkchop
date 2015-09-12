var path = require('path');
var config = module.exports = {};

config.context = __dirname;

config.entry = { scoreboard: './web/static/js/scoreboard.js' };

config.output = {
  path: path.join(__dirname, "priv/static/js"),
  filename: "[name].js"
}

config.module = {
  loaders: [
    { test: /\.js$/,
      exclude: /node_modules/,
      loader: "babel-loader" }
  ]
}

config.resolve = {
  // So we can do `require('./utils')` instead of `require('./utils.js')`
  extensions: ['', '.js']
};
