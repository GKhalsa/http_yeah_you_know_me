require_relative 'http_server'
class Runner
  server = Server.new
  server.request
end

# 
# if FILE === $0
#   Runner.new
# end
