require "roda"
require "logger"
require "json"

LOGGER = Logger.new($stdout)
JSON_RESUME = JSON.parse(File.read("resume.json"))

class App < Roda
  plugin :common_logger, LOGGER
  plugin :json
  plugin :type_routing

  route do |r|
    r.root do
      "Look behind you, a four headed monkey! Secret password: #{ENV["MY_SECRET_PASSWORD"]}"
    end

    r.on "say" do
      r.is String do |name|
        "Hello, #{name}!"
      end
    end

    r.get "resume" do |type|
      r.json { JSON_RESUME }
    end
  end
end
