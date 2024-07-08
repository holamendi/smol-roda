environment ENV.fetch("RACK_ENV") { "development" }

worker_count = Integer(ENV.fetch("PUMA_WORKERS") { 1 })
workers worker_count if worker_count > 1
worker_timeout 3600 if ENV.fetch("RACK_ENV", "development") == "development"

thread_count = Integer(ENV.fetch("PUMA_THREADS") { 1 })
threads thread_count, thread_count

port ENV.fetch("PORT") { 3000 }
