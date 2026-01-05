# frozen_string_literal: true

# :nocov:

module RedisHelper
  def self.redis_get(key)
    redis_client = resolve('redis')
    redis_client.get(key)
  end

  def self.redis_set(key, value)
    redis_client = resolve('redis')
    redis_client.set(key, value)
  end
end
# :nocov:
