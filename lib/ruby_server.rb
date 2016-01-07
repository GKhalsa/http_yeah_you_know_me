require 'socket'
require_relative 'response'

class Server
    attr_reader :request_count,
                :hello_count,
                :server

  def initialize(port = 9292)
    @server = TCPServer.new(port)
    @request_count = 0
    @request_lines = []
    @response = Response.new(server.accept)
  end

  def request
    loop do
      @client = @server.accept
      # client = @server.accept    # Wait for a client to connect

      while line = client.gets and !line.chomp.empty?
        @request_lines << line.chomp
      end
      # parsed_lines = Parser.new(@request_lines)
      # @request_count += 1

      @response.path = @request_lines[0].split[1]
      @response.path_check

      @client.close
    break if @request_lines[0].split[1] == "/shutdown"
    end
  end

  def path_finder
  end


  def headers
    ["http/1.1 200 ok",
    "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
    "server: ruby",
    "content-type: text/html; charset=iso-8859-1",
    "content-length: #{output.length}\r\n\r\n"].join("\r\n")
  end

  def word_search(word)
    dictionary = File.read("/usr/share/dict/words").split
    if dictionary.include?(word)
      "#{word.upcase} is a known word"
    else
      "#{word.upcase} is not a known word"
    end
  end

  def request_lines
    @request_lines.inspect
  end

  def parsed_debug_info
    "<pre>
     Verb: #{@request_lines[0].split[0]}
     Path: #{@request_lines[0].split[1]}
     Protocol: #{@request_lines[0].split[2]}
     Host: #{@request_lines[1].split[1][0..8]}
     Port: #{@request_lines[1].split[1][-4..-1]}
     Origin: #{@request_lines[1].split[1][0..8]}
     Accept: #{@request_lines[6].split[1]}
     </pre>"
  end
end

server = Server.new

server.request
