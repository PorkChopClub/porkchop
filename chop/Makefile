BIN := ./node_modules/.bin/

webpack: node_modules
	$(BIN)webpack

node_modules: package.json
	npm install

.PHONY: webpack
