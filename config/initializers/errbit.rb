# frozen_string_literal: true

Airbrake.configure do |config|
  config.api_key = '6f6804e481ac1dca19e87544c814cac4'
  config.host    = 'errbit.genesys.shefcompsci.org.uk'
  config.port    = 443
  config.secure  = config.port == 443
end
