Elo.configure do |config|
  config.use_FIDE_settings = false
  config.default_rating = 1000
  config.default_k_factor = 32
  config.k_factor(24) { rating >= 2100 && rating <= 2400 }
  config.k_factor(16) { rating > 2400 }
end
