require_relative 'formatter'

module RESPParser
  PONG = "+PONG\r\n"
  def self.parse(resp_command)
    command = resp_command.shift.downcase
    case command
    when 'echo'
      argument = resp_command.shift
      { echo: argument }
    when 'set'
      key = resp_command.shift
      value = resp_command.shift
      if resp_command.empty?
        { set: key, value: value }
      else
        expiry_type = resp_command.shift.downcase
        expiry = resp_command.shift
        case expiry_type
        when 'ex'
          expiry = Process.clock_gettime(Process::CLOCK_MONOTONIC) + expiry.to_i
          { set: key, value: value, expiry: expiry }
        when 'px'
          expiry = Process.clock_gettime(Process::CLOCK_MONOTONIC) + expiry.to_i / 1000
          { set: key, value: value, expiry: expiry }
        end
      end
    when 'get'
      key = resp_command.shift
      { get: key }
    else
      :ping
    end
  end
end