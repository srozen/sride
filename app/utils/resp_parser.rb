require_relative 'formatter'

module RESPParser
  PONG = "+PONG\r\n"
  def self.parse(resp_command)
    command = resp_command[0].downcase
    case command
    when 'echo'
      argument = resp_command[1]
      { echo: argument }
    when 'set'
      key, value = resp_command[1], resp_command[2]
      { set: key, value: value }
    when 'get'
      key = resp_command[1]
      { get: key }
    else
      :ping
    end
  end
end