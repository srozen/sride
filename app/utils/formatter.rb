module Formatter
  NULL_BULK_STRING = "$-1\r\n"

  def self.to_simple_string(str)
    return NULL_BULK_STRING if str.nil?

    format("+%s\r\n", str)
  end

  def self.to_bulk_string(str)
    return NULL_BULK_STRING if str.nil?

    format("$%d\r\n%s\r\n", str.bytesize, str)
  end
end