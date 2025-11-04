require 'minitest/autorun'
require_relative '../../app/utils/resp_parser'

class RESPParserTest < Minitest::Test
  def test_ping
    response = RESPParser.parse(%w[PING])
    assert_equal "+PONG\r\n", response
  end

  def test_echo
    response = RESPParser.parse(%w[echo foobar])
    assert_equal "$6\r\nfoobar\r\n", response
  end
end