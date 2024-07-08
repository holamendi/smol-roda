require "roda"
require "logger"

LOGGER = Logger.new($stdout)

class App < Roda
  plugin :common_logger, LOGGER

  route do |r|
    r.root do
      "Look behind you, a three headed monkey!"
    end

    r.on "say" do
      r.is String do |name|
        "Hello, #{name}!"
      end
    end
  end
end

run App.freeze.app
