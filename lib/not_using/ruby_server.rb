require 'pry'
require 'socket'
require_relative 'request'
require_relative 'response'
class Server

  def initialize(port = 9292)
    @server = TCPServer.new(port)
    @port = port
  end

  def router(server = @server, port = @port)

    request_count = 0
    hello_count = 0
    while (client = server.accept)
      request = Request.new(client)
      Response.new(request, request_count, hello_count)
      request_count += 1
      if request.request_lines[0].split[1] == "/hello"
        hello_count += 1
      elsif request.request_lines[0].split[1] == "/shutdown"
        break
      else
      end
    end
    client.close
  end
end

#
# response = Response.new(client, request_lines)
# server = Server.new
# server.request
# response.path_finder
# response.path_finder
