if ENV["APP_PROFILING"]
  require 'stackprof'
  require 'flamegraph'
  require 'rack-mini-profiler'
  Rack::MiniProfilerRails.initialize!(Rails.application)
end
