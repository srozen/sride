class YourRedisServer
  def initialize(port)
    @port = port
  end

  def start
    server = TCPServer.new(@port)
    loop do
      client = server.accept
      while (_line = client.gets.chomp)
        command = []
        params_number = _line.match(/^\*(\d)/)[1].to_i
        params_number.times do
          _bytes = client.gets.chomp
          _command = client.gets.chomp
          command.push(_command)
        end
        puts("Answering to #{command.inspect}")
        client.puts("+PONG\r\n")
      end
    end
  end
end