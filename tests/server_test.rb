require 'minitest/autorun'
require 'socket'
require_relative '../app/your_redis_server'

class YourRedisServerTest < Minitest::Test
  def setup
    port = rand(49152..65535)
    @server_thread = Thread.new { YourRedisServer.new(port).start }
    @client = TCPSocket.new('localhost', port)
  end

  def teardown
    @client.close rescue nil
    @server_thread.kill
  end

  def test_responds_to_ping_with_pong
    @client.puts("*1\r\n$4\r\nPING\r\n")
    response = @client.gets
    assert_equal "+PONG\r\n", response
  end

  def test_handles_multiple_ping_commands
    3.times do
      @client.puts("*1\r\n$4\r\nPING\r\n")
      assert_equal "+PONG\r\n", @client.gets
    end
  end

  def test_handles_ping_with_message
    @client.puts("*2\r\n$4\r\nPING\r\n$5\r\nhello\r\n")
    response = @client.gets
    assert_equal "+PONG\r\n", response
  end
end