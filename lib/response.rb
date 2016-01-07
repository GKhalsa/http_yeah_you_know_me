
class Response
  attr_reader :client, :hello_count, :request_count
  attr_accessor :path

  def initialize(client)
    @client = client
    @path = "/"
    @hello_count = 0
    @request_count = 0
  end

  def path_check
    if @path == "/hello"
      @hello_count += 1
      @client.puts hello
    elsif @path == "/datetime"
      @client.puts time
    elsif @path == "/shutdown"
      @client.puts shutdown
      client.close
    elsif @path[0..12] == "/word_search?"
      @client.puts word_search(@path[13..-1])
    else
      @client.puts parsed_debug_info
    end
  end

  def hello
    "Hello, World(#{hello_count})"
  end

  def shutdown
    "Total Requests: #{request_count}"
  end

  def time
    Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')
  end

end
