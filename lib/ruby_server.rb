require 'socket'

class Server
    attr_reader :request_count,
                :hello_count

  def initialize(port = 9292)
    @server = TCPServer.new(port)
    @request_count = 0
    @hello_count = 0
    @request_lines = []
  end

  def request
    loop do
      client = @server.accept    # Wait for a client to connect

      while line = client.gets and !line.chomp.empty?
        @request_lines << line.chomp
      end

      @request_count += 1

      if @request_lines[0].split[1] == "/hello"
        @hello_count += 1
        client.puts hello
      elsif @request_lines[0].split[1] == "/datetime"
        client.puts time
      elsif @request_lines[0].split[1] == "/shutdown"
        client.puts shutdown
        client.close
      else

      # client.puts response
      # client.puts headers
      client.puts parsed_debug_info
      client.puts request_lines
      end
      @request_lines = []

      client.close
    end
  end
    def response
      response1
      time
    end

  # def response
  #   client.puts "Hello, World (#{@request_count/2})"
  #     # # # client.puts "Time is #{Time.now}"
  #     # client.puts headers
  #     # client.puts output
  #     # client.puts request_lines
  # end
    def hello
      "Hello, World(#{hello_count/2})"
    end

    def shutdown
      "Total Requests: #{request_count/2}"
    end

    def response1
      "<pre>" + @request_lines.join("\n") + "</pre>"
    end

    def output
      "<html><head></head><body>#{response1}</body></html>"
    end

    def time
      Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')
    end

    def headers
      ["http/1.1 200 ok",
      "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
      "server: ruby",
      "content-type: text/html; charset=iso-8859-1",
      "content-length: #{output.length}\r\n\r\n"].join("\r\n")
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
