Elo.configure do |config|
  config.use_FIDE_settings = false
  config.default_rating = 1000
  config.default_k_factor = 20
  config.k_factor(40) { games_played < 30 }
  config.k_factor(10) { rating > 1200 }
end
