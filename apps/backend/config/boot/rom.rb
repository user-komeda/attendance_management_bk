# frozen_string_literal: true

require_relative '../container'
# app/boot/rom.rb
Container.register_provider(:rom) do
  prepare do
    require 'rom'
    require 'rom-sql'
    require 'pg'
    config = ROM::Configuration.new(:sql, Secrets.get('DB_URL'))
    register('db.config', config)
  end
end
