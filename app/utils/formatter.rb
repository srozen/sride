module Formatter
  PONG = "+PONG\r\n"
  NULL_BULK_STRING = "$-1\r\n"

  def self.to_bulk_string(str)
    return NULL_BULK_STRING if str.nil?
    return PONG if str.downcase == 'ping'

    format("$%d\r\n%s\r\n", str.bytesize, str)
  end
end