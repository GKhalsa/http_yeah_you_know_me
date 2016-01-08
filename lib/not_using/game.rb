def guessing_game
  if @request_lines[0].split[0] == "POST" && @request_lines[0].split[1] == "/start_game"
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
      if not game
      @client.puts headers
    elsif game
      client.puts redirect_headers
    end
      @client.puts response
  end
end

def start_game
  "Good luck!"
end

def guessing
  "You've made #{@game_count} guesses sucka!"
end



# def header
#   ["http/1.1 200 ok",
#   "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
#   "server: ruby",
#   "content-type: text/html; charset=iso-8859-1",
#   "content-length: #{output.length}\r\n\r\n"].join("\r\n")
# end
