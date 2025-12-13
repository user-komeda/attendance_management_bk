# frozen_string_literal: true

require_relative '../container'
require 'redis'

Container.register(:redis) do
  Redis.new(
    url: 'redis://default:password@localhost:6379/0',
    connect_timeout: 0.2,
    read_timeout: 0.2,
    write_timeout: 0.2
  )
end
