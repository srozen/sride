module RESPParser
  PONG = "+PONG\r\n"
  def self.parse(resp_command)
    command = resp_command[0].downcase
    case command
    when 'ping'
      PONG
    when 'echo'
      argument = resp_command[1]
      RESPParser.to_bulk_string(argument)
    else
      PONG
    end
  end

  def self.to_bulk_string(answer)
    format("$%d\r\n%s\r\n", answer.bytesize, answer)
  end
end