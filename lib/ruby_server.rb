class Server

  require 'socket'

  tcp_server = TCPServer.new(9292)
  server_count = 0

  loop do

    client = tcp_server.accept
    puts "Ready for a request"
    request_lines = ["Hello, World (#{server_count/2})"]

    while line = client.gets and !line.chomp.empty?
      request_lines << line.chomp
    end

    server_count += 1
    puts "Got this request:"
    puts request_lines.inspect

    puts "Sending response."
    response = "<pre>" + request_lines.join("\n") + "</pre>"
    output = "<html><head></head><body>#{response}</body></html>"
    headers = ["http/1.1 200 ok",
              "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
              "server: ruby",
              "content-type: text/html; charset=iso-8859-1",
              "content-length: #{output.length}\r\n\r\n"].join("\r\n")
    client.puts headers
    client.puts output

    puts ["Wrote this response:", headers, output].join("\n")
    puts "\nResponse complete."


    client.close

    def lines
      request_lines
    end


  end
end
