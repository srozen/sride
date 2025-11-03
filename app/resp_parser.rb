module RESPParser
  def self.parse(resp_command)
    command = resp_command[0].downcase
    case command
    when 'ping'
      "+PONG\r\n"
    when 'echo'
      "$#{resp_command[1].bytesize}\r\n#{resp_command[1]}\r\n"
    else
      "+PONG\r\n"
    end
  end
end