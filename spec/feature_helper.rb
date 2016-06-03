require 'rails_helper'
require 'capybara/rails'
require 'capybara/poltergeist'
require 'capybara-screenshot/rspec'

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(
    app,
    phantomjs: File.expand_path("../../node_modules/.bin/phantomjs", __FILE__),
    phantomjs_options: ['--load-images=no'],
    window_size: [1920, 1080],
    js_errors: true
  )
end
Capybara.javascript_driver = :poltergeist
Capybara.default_driver = :poltergeist
Capybara.server = :puma

RSpec.configure do |config|
  config.include Warden::Test::Helpers
  config.before(:suite) do
    Porkchop::Application.load_tasks
    Rake::Task[:webpack].invoke
    Warden.test_mode!
  end
  config.after :each do
    Warden.test_reset!
  end
end
