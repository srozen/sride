require 'minitest/autorun'
require_relative '../../app/utils/formatter'

class FormatterTest < Minitest::Test
  def test_to_bulk_string
    assert_equal "$6\r\nfoobar\r\n", Formatter.to_bulk_string('foobar')
    assert_equal "$0\r\n\r\n", Formatter.to_bulk_string('')
    assert_equal "$-1\r\n", Formatter.to_bulk_string(nil)
  end
end
