source 'https://rubygems.org'

# This should be first.
gem 'mime-types', '~> 2.6.1', require: 'mime/types/columnar'

gem 'rails', '4.2.0'
gem 'pg'
gem 'puma'
gem 'sdoc', '~> 0.4.0', group: :doc
gem 'dotenv-rails'

# CSS
gem 'sass-rails', '~> 5.0'
gem 'sassc-rails'
gem 'bourbon'
gem 'normalize-rails', github: 'markmcconachie/normalize-rails'

# Javascript
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'
gem 'jquery-rails'

# Frontend
gem 'jbuilder', '~> 2.0'
gem 'haml'
gem 'simple_form'

gem 'omniauth-twitter'
gem 'cancancan', '~> 1.10'
gem 'slack-notifier'
gem 'bugsnag'
gem 'elo', github: 'jhawthorn/elo'

gem 'stackprof'
gem 'flamegraph'
gem 'rack-mini-profiler'

group :development, :test do
  gem 'rspec-rails', '~> 3.0'
  gem 'pry-rails'

  gem 'factory_girl_rails', require: false
end

group :test do
  # Test fast or die trying.
  gem 'simplecov', require: false
  gem 'simplecov-rcov', require: false
  gem 'codeclimate-test-reporter', require: false
  gem 'capybara', require: false
  gem 'poltergeist', require: false
  gem 'database_cleaner', require: false
  gem 'shoulda-matchers', require: false

  gem 'visdiff'
end
