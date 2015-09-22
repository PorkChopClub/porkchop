BIN := ./node_modules/.bin/
SASS_OPTS := --include-path bower_components \
	--include-path node_modules/bourbon/app/assets/stylesheets \
	web/static/css/pork.scss \
	priv/static/css/pork.css

default: webpack sass

webpack: node_modules
	$(BIN)webpack

node_modules: package.json
	npm install

sass: node_modules
	$(BIN)node-sass $(SASS_OPTS)

.PHONY: default webpack sass
