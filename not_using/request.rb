class Request
  attr_reader :request_lines,
              :client

  def initialize(client)
    @request_lines = request(client)
    @client = client
    puts "#{request_lines}"
  end

  def request(client)
    request_lines = []
    while line = client.gets and !line.chomp.empty?
      request_lines << line.chomp
    end
    request_lines
  end
end
