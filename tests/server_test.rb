require 'minitest/autorun'
require 'socket'
require_relative '../app/your_redis_server'

class YourRedisServerTest < Minitest::Test
  def setup
    @port = rand(49152..65535)
    @server_thread = Thread.new { YourRedisServer.new(@port).start }
    @client = TCPSocket.new('localhost', @port)
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

  def test_handles_get_set_commands
    @client.puts("*3\r\n$3\r\nSET\r\n$5\r\nhello\r\n$5\r\nworld\r\n")
    assert_equal "+OK\r\n", @client.gets

    @client.puts("*2\r\n$3\r\nGET\r\n$5\r\nhello\r\n")
    assert_equal "$5\r\n", @client.gets
    assert_equal "world\r\n", @client.gets
  end

  def test_handles_multiple_clients
    clients = 3.times.map { TCPSocket.new('localhost', @port) }
    clients.each do |client|
      client.puts("*1\r\n$4\r\nPING\r\n")
      response = client.gets
      assert_equal "+PONG\r\n", response
    end
    clients.each { |client| client.close }
  end
end