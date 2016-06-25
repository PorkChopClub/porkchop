# PorkChop.club [![Build Status](https://travis-ci.org/porkchopclub/porkchop.svg?branch=master)](https://travis-ci.org/porkchopclub/porkchop) [![Code Climate](https://codeclimate.com/github/porkchopclub/porkchop/badges/gpa.svg)](https://codeclimate.com/github/porkchopclub/porkchop) [![Test Coverage](https://codeclimate.com/github/porkchopclub/porkchop/badges/coverage.svg)](https://codeclimate.com/github/porkchopclub/porkchop/coverage)

The [Stembolt](https://stembolt.com/) ping pong scoreboard and stat-tracking application.

## Development

Requirements: a reasonable version on NodeJS, whatever Ruby version is
specified in the `Gemfile`, and a Redis server (on an Ubuntu system, all you
need to do is `sudo apt-get install redis-server`).

```shell
# Initial setup
$ ./bin/setup
$ npm install

# Actual development (run simultaneously)
$ bundle exec rails s -p 2277
$ bundle exec sidekiq
$ npm run watch
```
