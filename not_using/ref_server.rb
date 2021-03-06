class Server

  require 'socket'

  tcp_server = TCPServer.new(9292)
  server_count = 0

  loop do
    client = tcp_server.accept

    # this is the request_lines array
    puts "Ready for a request"
    request_lines = ["Hello, World (#{server_count})"] #possible

    while line = client.gets and !line.chomp.empty?
      request_lines << line.chomp

    end
    # ["HTTP/1.1 302 Found",
          # "Location: http://127.0.0.1:9292/game\r\n\r\n"].join("\r\n")

    #server_count += 1
    #puts "Got this request:"
    #puts request_lines.inspect

    puts "Sending response."
    response = "<pre>" + request_lines.join("\n") + "</pre>"
    output = "<html><head></head><body>#{response}</body></html>"
    headers = ["HTTP/1.1 200 ok",
              "Location: http://127.0.0.1:9292/game",

              "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
              "server: ruby",
              "content-type: text/html; charset=iso-8859-1",
              "content-length: #{output.length}\r\n\r\n"].join("\r\n")

    client.puts headers
    client.puts output

    puts ["Wrote this response:", headers, output].join("\n")
    puts "\nResponse complete."


    client.close

    puts "<pre>"
    puts "Verb: #{request_lines[1].split[0]}"
    puts "Path: #{request_lines[6].split[-1][21..-1]}"
    puts "Protocol: #{request_lines[1].split[2]}"
    puts "Host: #{request_lines[2].split[1][0..-6]}"
    puts "Port: #{request_lines[2].split[1][-4..-1]}"
    puts "Origin: #{request_lines[2].split[1][0..-6]}"
    puts "Accept: #{request_lines[5].split[1]}"
    puts "</pre>"

  end

end
