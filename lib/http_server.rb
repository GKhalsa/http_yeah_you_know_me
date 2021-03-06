require 'socket'
require_relative 'response_messages'

class Server
  attr_reader :request_count,
              :hello_count,
              :client,
              :port

  def initialize(port = 9292)
    @server = TCPServer.new(port)
    @request_count = 0
    @hello_count = -1
    @request_lines = []
    @client = nil
    @port = port
  end

  def request
    loop do
      @client = @server.accept
      while line = @client.gets and !line.chomp.empty?
        @request_lines << line.chomp
      end
      @request_count += 1
      path_finder
      @request_lines = []
      @client.close
    end
  end

  def path_finder
    if path == "/hello"
      @hello_count += 1
      response = ResponseMessages.hello(hello_count)
    elsif path == "/datetime"
      response = ResponseMessages.time
    elsif path == "/shutdown"
      @client.puts shutdown
      @client.close
    elsif path[0..17] == "/word_search?word="
      @client.puts word_search(path[18..-1])
    else
      @client.puts parsed_debug_info
    end

    @client.puts response
  end

  def path
    @request_lines[0].split[1]
  end

  def word_search(word)
    dictionary = File.read("/usr/share/dict/words").split
    if dictionary.include?(word)
      "#{word.upcase} is a known word"
    else
      "#{word.upcase} is not a known word"
    end
  end

  def shutdown
    "Total Requests: #{request_count}"
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
