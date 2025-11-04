require 'minitest/autorun'
require_relative '../../app/utils/resp_parser'

class RESPParserTest < Minitest::Test
  def test_ping
    response = RESPParser.parse(%w[PING])
    expected = :ping
    assert_equal expected, response
  end

  def test_echo
    response = RESPParser.parse(%w[echo foobar])
    expected = { echo: 'foobar' }
    assert_equal expected, response
  end
end