require 'minitest/autorun'
require 'minitest/pride'
require 'socket'
require_relative '../lib/http_server'

class HTTPServerTest < Minitest::Test
  attr_reader :server

  def setup
    @server = Server.new("9292")
  end

  def test_server_is_a_server
    assert server
  end

  def test_server_has_a_port
    assert_equal "9292", server.port.to_s
  end



end
