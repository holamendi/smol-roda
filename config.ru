require "roda"

class App < Roda
  route do |r|
    r.root do
      "Look behind you, a three headed monkey! (test1)"
    end
  end
end

run App.freeze.app
