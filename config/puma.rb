worker_count = Integer(ENV.fetch("PUMA_WORKERS") { 1 })
workers worker_count if worker_count > 1
worker_timeout 3600 if ENV.fetch("RACK_ENV", "development") == "development"
port ENV.fetch("PORT") { 3000 }
environment ENV.fetch("RACK_ENV") { "development" }
