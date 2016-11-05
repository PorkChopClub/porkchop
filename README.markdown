# PorkChop.club [![Build Status](https://travis-ci.org/PorkChopClub/porkchop.svg?branch=master)](https://travis-ci.org/porkchopclub/porkchop) [![Code Climate](https://codeclimate.com/github/porkchopclub/porkchop/badges/gpa.svg)](https://codeclimate.com/github/porkchopclub/porkchop) [![Test Coverage](https://codeclimate.com/github/porkchopclub/porkchop/badges/coverage.svg)](https://codeclimate.com/github/porkchopclub/porkchop/coverage)

The [Stembolt](https://stembolt.com/) ping pong scoreboard and stat-tracking application.

## Development

Requirements: a reasonable version on NodeJS, whatever Ruby version is
specified in the `Gemfile`, and a Redis server (on an Ubuntu system, all you
need to do is `sudo apt-get install redis-server`).

```shell
# Run these to these to get the project setup:
$ ./bin/setup

# For development run these simultaneously:
$ bundle exec rails s -p 2277
$ bundle exec sidekiq
$ npm run watch
# If you want to use LiveReload, also run:
$ bundle exec guard
```

# Style Guides

This project inherits from Airbnb's JavaScript style guide, with a few changes.
Run `npm run lint` to see your violations. Use `npm run autofix` to fix any
that can be automatically fixed.
