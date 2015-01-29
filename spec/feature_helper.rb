require 'rails_helper'
require 'capybara/rails'
require 'capybara/poltergeist'

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new app,
    window_size: [1920, 1080],
    js_errors: true
end
Capybara.javascript_driver = :poltergeist
Capybara.default_driver = :poltergeist
