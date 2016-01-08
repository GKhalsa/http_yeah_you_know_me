class Response
  attr_reader :request_count,
              :hello_count

  def initialize(request, request_count, hello_count)
    @client = request.client
    @request_lines = request.request_lines
    # binding.pry
    @hello_count = hello_count
    @request_count = request_count
    @game_count = 0
    path_finder
  end

  def path_finder
    if @request_lines[0].split[1] == "/hello"
      @hello_count += 1
      response = hello
    elsif @request_lines[0].split[1] == "/datetime"
      response = time
    elsif @request_lines[0].split[1] == "/shutdown"
      response = shutdown
    elsif @request_lines[0].split[1][0..17] == "/word_search?word="
      response = word_search(@request_lines[0].split[1][18..-1])
    else
      response = parsed_debug_info
    end
    output = "<html><head></head><body>#{response}</body></html>"
    headers = ["http/1.1 200 ok",
              "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
              "server: ruby",
              "content-type: text/html; charset=iso-8859-1",
              "content-length: #{output.length}\r\n\r\n"].join("\r\n")
    @client.puts headers
    @client.puts output

  end

  def hello
    "Hello, World(#{@hello_count})"
  end

  def shutdown
    "Total Requests: #{@request_count}"
  end

  def time
    Time.now.strftime("%I:%M%p on %A, %B %e, %Y")
  end

  def word_search(word)
    dictionary = File.read("/usr/share/dict/words").split
    if dictionary.include?(word)
      "#{word.upcase} is a known word"
    else
      "#{word.upcase} is not a known word"
    end
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
