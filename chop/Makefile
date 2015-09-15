default: webpack sass

webpack: node_modules
	node node_modules/webpack/bin/webpack.js

node_modules: package.json
	npm install

sass:
	(bundle check || bundle install) && bundle exec sass -r bourbon web/static/css/pork.scss priv/static/css/pork.css

.PHONY: default webpack sass
