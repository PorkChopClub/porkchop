Elo.configure do |config|
  config.use_FIDE_settings = false
  config.default_rating = 1000
  config.default_k_factor = 25
  config.k_factor(15) { rating >= 1100 && rating <= 1500 }
  config.k_factor(10) { rating > 1500 }
end
