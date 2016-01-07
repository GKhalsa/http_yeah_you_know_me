require 'socket'

class Server
    attr_reader :request_count

  def initialize(port = 9292)
    @server = TCPServer.new(port)
    @request_count = 0
    @request_lines = []
  end

  def request
    loop do
      client = @server.accept    # Wait for a client to connect

      while line = client.gets and !line.chomp.empty?
        @request_lines << line.chomp
      end
      #
      # # client.puts "Hello !"
      # # client.puts "Time is #{Time.now}"
      @request_count += 1
      client.puts "Hello, World (#{@request_count/2})"
      # client.puts "#{@request_lines}.inspect"
      client.puts headers
      client.puts output
      client.close

      @request_lines = []

    end
  end

    def response
      "<pre>" + @request_lines.join("\n") + "</pre>"
    end

    def output
      "<html><head></head><body>#{response}</body></html>"
    end

    def headers
      ["http/1.1 200 ok",
      "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
      "server: ruby",
      "content-type: text/html; charset=iso-8859-1",
      "content-length: #{output.length}\r\n\r\n"].join("\r\n")
    end

end

server = Server.new

server.request
server.headers
