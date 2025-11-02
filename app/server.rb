require "socket"

class YourRedisServer
  def initialize(port)
    @port = port
  end

  def start
    server = TCPServer.new(@port)
    loop do
      client = server.accept
      while (_line = client.gets.chomp)
        begin
          command = []
          params_number = _line.match(/^\*(\d)/)[1].to_i
          params_number.times do
            _bytes = client.gets.chomp
            _command = client.gets.chomp
            command.push(_command)
          end
          puts("Answering to #{command.inspect}")
          client.puts("+PONG\r\n")
        rescue
          puts 'Unrecognized command, exiting...'
          client.close
        end
      end
    end
  end
end

YourRedisServer.new(6379).start
