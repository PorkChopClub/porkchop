source 'https://rubygems.org'

ruby '2.4.0'

# FIXME: This is because 2.2.x is blowing up on Travis. Remove when it doesn't.
gem 'rainbow', '>= 2.1.0', '< 2.2.0'

# This should be first.
gem 'mime-types', '~> 2.6.1', require: 'mime/types/columnar'

gem 'rails', '~> 5.0.1'
gem 'rack-cors'
gem 'pg'
gem 'puma'
gem 'sidekiq'
gem 'kaminari'
gem 'fog-aws'
gem 'carrierwave', '>= 1.0.0.rc', '< 2.0'

# CSS
gem 'sass-rails', '~> 5.0'
gem 'sassc-rails'
gem 'bourbon'
gem 'normalize-rails'

# Javascript
gem 'uglifier', '>= 1.3.0'
gem 'jquery-rails'

gem 'webpacker'

# Frontend
gem 'jbuilder', '~> 2.0'
gem 'hamlit'
gem 'simple_form'
gem 'font-awesome-rails'

gem 'slack-notifier'
gem 'bugsnag'
gem 'elo2'
gem 'faraday'
gem 'devise'
gem 'cancancan'
gem 'active_model_serializers', '~> 0.10.0'
gem 'games_back', '~> 1.0'

group :production do
  gem 'redis-rails'

  # We use letsencrypt to configure SSL certs on herku
  gem 'platform-api', git: 'http://github.com/jalada/platform-api', branch: 'master'
  gem 'letsencrypt-rails-heroku'
end

group :development do
  gem 'stackprof', require: false
  gem 'flamegraph', require: false
  gem 'rack-mini-profiler', require: false
  gem 'letter_opener'
  gem 'rack-livereload', require: false
  gem 'guard-livereload', '~> 2.5', require: false
end

group :development, :test do
  gem 'dotenv-rails'
  gem 'rspec-rails', '~> 3.6.0.beta1'
  gem 'rails-controller-testing'
  gem 'pry-rails'
  gem 'pry-stack_explorer'

  gem 'ffaker', require: false
  gem 'factory_girl_rails', require: false
end

group :test do
  # Test fast or die trying.
  gem 'simplecov', require: false
  gem 'codeclimate-test-reporter', '~> 1.0.0'
  gem 'capybara', '~> 2.10.1', require: false
  gem 'capybara-screenshot', require: false
  gem 'poltergeist', require: false
  gem 'database_cleaner', require: false
  gem 'shoulda-matchers', require: false
  gem 'timecop', require: false

  gem 'visdiff'
end
