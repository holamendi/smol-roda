require_relative 'test_helper'

class AppTest < Minitest::Test
  include Rack::Test::Methods

  def app
    App
  end

  def test_root_path
    get '/'
    assert_equal 200, last_response.status
    assert_equal "Look behind you, a three headed monkey?", last_response.body
  end

  def test_say_path_with_name
    get '/say/World'
    assert_equal 200, last_response.status
    assert_equal "Hello, World!", last_response.body
  end

  def test_say_path_with_different_names
    names = {
      "Alice" => "Hello, Alice!",
      "Bob123" => "Hello, Bob123!",
      "Another-Name" => "Hello, Another-Name!"
    }

    names.each do |name, expected_body|
      get "/say/#{name}"
      assert_equal 200, last_response.status, "Failed for name: #{name}"
      assert_equal expected_body, last_response.body, "Failed for name: #{name}"
    end
  end

  def test_resume_path
    get '/resume', {}, { 'HTTP_ACCEPT' => 'application/json' }
    assert_equal 200, last_response.status
    assert_equal "application/json", last_response.headers["Content-Type"]

    expected_json = JSON.parse(File.read('resume.json'))
    actual_json = JSON.parse(last_response.body)
    assert_equal expected_json, actual_json
  end
end
