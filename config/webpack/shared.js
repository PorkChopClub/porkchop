// Note: You must restart bin/webpack-watcher for changes to take effect

var webpack = require('webpack')
var path = require('path')
var process = require('process')
var glob = require('glob')
var extname = require('path-complete-extname')
var distDir = process.env.WEBPACK_DIST_DIR

if(distDir === undefined) {
  distDir = 'packs'
}

config = {
  entry: glob.sync(path.join('app', 'javascript', 'packs', '*.js*')).reduce(
    function(map, entry) {
      var basename = path.basename(entry, extname(entry))
      map[basename] = [
        "jquery-ujs",
        "babel-polyfill",
        "fonts",
        path.resolve(entry)
      ]
      return map
    }, {}
  ),

  output: { filename: '[name].js', path: path.resolve('public', distDir) },

  module: {
    rules: [
      {
        test: /\.js(.erb)?$/,
        exclude: /node_modules/,
        loader: 'babel-loader',
        options: {
          plugins: [
            "transform-function-bind",
            "transform-object-rest-spread"
          ],
          presets: [
            "react",
            ["env", {
              "targets": {
                "browsers": "> 3% in US"
              }
            }]
          ]
        }
      },
      {
        test: /.erb$/,
        enforce: 'pre',
        exclude: /node_modules/,
        loader: 'rails-erb-loader',
        options: {
          runner: 'DISABLE_SPRING=1 bin/rails runner'
        }
      },
    ]
  },

  plugins: [
    new webpack.ProvidePlugin({
      fetch: 'imports-loader?this=>global!exports-loader?global.fetch!whatwg-fetch',
      jQuery: 'jquery',
      $: 'jquery',
      React: 'react'
    }),
    new webpack.EnvironmentPlugin(Object.keys(process.env))
  ],

  resolve: {
    extensions: [ '.js' ],
    modules: [
      path.resolve('app/javascript'),
      path.resolve('node_modules')
    ]
  },

  resolveLoader: {
    modules: [ path.resolve('node_modules') ]
  }
}

module.exports = {
  distDir: distDir,
  config: config
}
