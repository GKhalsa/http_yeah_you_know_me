class Parser

  def parsed_lines
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
