class Parser

  def initialize(request_lines)
    @verb =  request_lines[1].split[0]
    "Path: #{request_lines[6].split[-1][21..-1]}"
    "Protocol: #{request_lines[1].split[2]}"
    "Host: #{request_lines[2].split[1][0..-6]}"
    "Port: #{request_lines[2].split[1][-4..-1]}"
    "Origin: #{request_lines[2].split[1][0..-6]}"
    "Accept: #{request_lines[5].split[1]}"
    "</pre>"
  end
end
