require 'logger'
require_relative 'resp_parser'
class YourRedisServer

  def initialize(port)
    @logger = Logger.new(STDOUT)
    @port = port
  end

  def start
    server = TCPServer.new(@port)
    loop do
      Thread.start(server.accept) do |client|
        begin
          while (line = client.gets)
            @logger.info("Received #{line.inspect}")
            _line = line.chomp
            command = []
            params_number = _line.match(/\d+/)[0].to_i
            params_number.times do
              _bytes = client.gets.chomp
              _command = client.gets.chomp
              command.push(_command)
            end
            @logger.info("Answering to #{command.inspect}")
            answer = RESPParser.parse(command)
            client.puts(answer)
          end
        rescue Exception => e
          @logger.error(e.message)
        end
        @logger.info("Closing connection")
        client.close
      end
    end
  end
end