if ENV['AWS_ACCESS_KEY_ID'] && ENV['AWS_SECRET_ACCESS_KEY']
  CarrierWave.configure do |config|
    config.fog_provider = 'fog/aws'
    config.fog_credentials = {
      provider: 'AWS',
      aws_access_key_id: ENV.fetch('AWS_ACCESS_KEY_ID'),
      aws_secret_access_key: ENV.fetch('AWS_SECRET_ACCESS_KEY')
    }
    config.fog_directory  = 'porkchop-uploads'
    config.fog_attributes = { 'Cache-Control' => "max-age=#{365.day.to_i}" }
  end
end
