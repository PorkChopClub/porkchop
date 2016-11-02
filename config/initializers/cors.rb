Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins "porkchop.club"
    resource "/api/*",
      headers: :any,
      methods: %i[get post put delete options]
  end
end
