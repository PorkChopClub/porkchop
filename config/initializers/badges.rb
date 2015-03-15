require "badger"

Rails.application.config.to_prepare do
  Badger.reload
end
