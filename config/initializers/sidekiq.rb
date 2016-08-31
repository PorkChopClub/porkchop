if ENV['REDIS_PROVIDER']
  Sidekiq.configure_server do |config|
    config.redis = {
      size: 4,
      url: ENV['REDIS_PROVIDER']
    }
  end

  Sidekiq.configure_client do |config|
    config.redis = {
      size: 1,
      url: ENV['REDIS_PROVIDER']
    }
  end
end
