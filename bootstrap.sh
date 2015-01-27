#!/bin/sh
bundle exec rake db:drop
bundle exec rake db:setup
bundle exec rake db:test:prepare
