class ResponseMessages
  # attr_accessor :langauge

  # writer
  # def self.language=
  #   @language = "english"
  # end

  # reader
  # def self.language
  #   @language = "english"
  # end

  def self.hello(hello_count)
    "Hello, World(#{hello_count})"
  end

  def self.time
    Time.now.strftime("%I:%M%p on %A, %B %e, %Y")
  end
end

# ResponseMessages.new.language = "swedish"
