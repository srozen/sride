require 'logger'
require_relative 'utils/resp_parser'
class YourRedisServer

  def initialize(port)
    @logger = Logger.new(STDOUT)
    @port = port
    @key_value_store = {}
  end

  def start
    server = TCPServer.new(@port)
    loop do
      Thread.start(server.accept) do |client|
        client_loop(client)

        @logger.info("Closing connection")
        client.close
      end
    end
  end

  def client_loop(client)
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
        parsed_command = RESPParser.parse(command)
        answer = process_command(parsed_command)
        client.puts(answer)
      end
    rescue Exception => e
      @logger.error(e.message)
    end
  end

  def process_command(command)
    case command
    in { echo: argument }
      Formatter.to_bulk_string(argument)
    in { set: key, value: value }
      set(key, value)
      Formatter.to_bulk_string('OK')
    in { get: key }
      answer = get(key)
      Formatter.to_bulk_string(answer)
    end
  end

  def set(key, value)
    @key_value_store[key] = value
  end

  def get(key)
    @key_value_store[key]
  end
end