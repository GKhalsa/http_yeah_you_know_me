require 'pry'
require 'socket'
class Server
    attr_reader :request_count,
                :hello_count,
                :game_count
                :client

  def initialize(port = 9292)
    @server = TCPServer.new(port)
    @request_count = 0
    @hello_count = 0
    @game_count = 0
    @request_lines = []
    @client = nil
  end

  def request
    loop do
      @client = @server.accept    # Wait for a client to connect
      while line = @client.gets and !line.chomp.empty?
        @request_lines << line.chomp
      end
      @request_count += 1
      # headers
      path_finder
      @request_lines = []
      @client.close
    end
  end


  def path_finder
    if @request_lines[0].split[1] == "/hello"
      @hello_count += 1
      @client.puts hello
    elsif @request_lines[0].split[1] == "/datetime"
      @client.puts time
    elsif @request_lines[0].split[1] == "/shutdown"
      @client.puts shutdown
      @client.close
    elsif @request_lines[0].split[1][0..17] == "/word_search?word="
      @client.puts word_search(@request_lines[0].split[1][18..-1])
    elsif @request_lines[0].split[0] == "POST" && @request_lines[0].split[1] == "/start_game"
      @client.puts start_game

    elsif @request_lines[0].split[0] == "GET" && @request_lines[0].split[1] == "/game"
      @client.puts guessing
      @client.puts "guess = #{@guess}"
      number = 5
      if @guess < number
        @client.puts "your guess was #{@guess} and it was too low"
      elsif @guess > number
        @client.puts "your guess was #{@guess} and it was too high"
      else @guess == number
        @client.puts "bingo!"
      end

    elsif @request_lines[0].split[0] == "POST" && @request_lines[0].split[1][0..4] == "/game"
      @game_count += 1
      @guess = @request_lines[0].split[1][12..-1].to_i
      headers
    else
      @client.puts parsed_debug_info
      @client.puts request_lines
    end
  end

  def guessing
    "You've made #{@game_count} guesses sucka!"
  end

  def word_search(word)
    dictionary = File.read("/usr/share/dict/words").split
    if dictionary.include?(word)
      "#{word.upcase} is a known word"
    else
      "#{word.upcase} is not a known word"
    end
  end

  def hello
    "Hello, World(#{hello_count})"
  end

  def shutdown
    "Total Requests: #{request_count}"
  end

  def time
    Time.now.strftime("%I:%M%p on %A, %B %e, %Y")
  end

  # def headers
  #   ["http/1.1 200 ok",
  #   "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
  #   "server: ruby",
  #   "content-type: text/html; charset=iso-8859-1",
  #   "content-length: #{output.length}\r\n\r\n"].join("\r\n")
  # end

  def start_game
    "Good luck!"
  end

  def headers
    ["HTTP/1.1 302 Found",
             "Location: http://127.0.0.1:9292/game\r\n\r\n"].join("\r\n")
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
# def response1
#   "<pre>" + @request_lines.join("\n") + "</pre>"
# end

# def output
#   "<html><head></head><body>#{path_finder}</body></html>"
# end

server = Server.new

server.request
