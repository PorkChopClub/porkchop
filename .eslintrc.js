module.exports = {
  "extends": "airbnb",
  "plugins": [
    "react"
  ],
  "settings": {
    "import/resolver": {
      "webpack": {
        "config": "webpack.config.js"
      }
    }
  },
  "globals": {
    "ga": true
  },
  "rules": {
    "semi": ["error", "never"],
    "space-before-function-paren": ["error", "never"],
    "func-names": ["error", "never"],
    "new-cap": ["error", {
      "capIsNewExceptions": ["Line"]
    }]
  }
};
