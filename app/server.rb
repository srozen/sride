require "socket"
require_relative "your_redis_server"

YourRedisServer.new(6379).start
