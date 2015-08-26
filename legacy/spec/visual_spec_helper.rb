require 'feature_helper'

require 'visdiff/rspec'

RSpec.configure do |config|
  if ENV['VISDIFF_API_KEY']
    config.visdiff.enable
    config.visdiff.api_key = ENV['VISDIFF_API_KEY']
    config.visdiff.revision_from_git!
  end
end
