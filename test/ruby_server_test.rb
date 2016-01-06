require 'minitest/autorun'
require 'minitest/pride'
require 'socket'
require 'hurley'

class RubyServerTest < Minitest::Test
  attr_reader :client,
              :response

  def setup
    @client = Hurley::Client.new "http://127.0.0.1:9292"
    @response = Hurley.get("http://127.0.0.1:9292")
    @counter = 0
  end

  def self.test_order
  :alpha
  end

  def test_server_can_connect
    assert response.success?
  end

  def test_status_type_is_success
    assert_equal :success, response.status_type
  end

  def test_server_has_a_body
    assert_equal "<html><head></head><body><pre>Hello, World (#{@counter += 1})
    GET / HTTP/1.1
    User-Agent: Hurley v0.2
    Accept-Encoding: gzip;q=1.0,deflate;q=0.6,identity;q=0.3
    Accept: */*
    Connection: close
    Host: 127.0.0.1:9292</pre></body></html>", response.body
  end


  def test_server_has_a_status_code
    assert_equal 200, response.status_code
  end

  def test_server_has_a_header
    skip
    assert_equal
  end

  def test_server_has_a_scheme
    assert_equal "http", client.scheme
  end

  def test_server_has_a_host
    assert_equal "127.0.0.1", client.host
  end

  def test_server_has_a_port
    assert_equal 9292, client.port
  end
end
