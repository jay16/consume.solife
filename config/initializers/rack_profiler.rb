#encoding: utf-8
require 'rack-mini-profiler'

# initialization is skipped so trigger it
Rack::MiniProfilerRails.initialize!(Rails.application)

# Custom middleware ordering (required if using Rack::Deflate with Rails)
# Rails.application.middleware.delete(Rack::MiniProfiler)
# Rails.application.middleware.insert_after(Rack::Deflater, Rack::MiniProfiler)

Rack::MiniProfiler.config.position = 'right'
Rack::MiniProfiler.config.start_hidden = false

# `Rack::MiniProfiler.authorize_request` not work without this config
if false and Rails.env.production?
  Rack::MiniProfiler.config.authorization_mode = :whitelist 
end

Rack::MiniProfiler.config.skip_paths = ['/api/', '/solife']
