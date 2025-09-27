# frozen_string_literal: true

require_relative '../container'
# app/boot/rom.rb
Container.register_provider(:rom) do
  prepare do
    require 'rom'
    require 'rom-sql'
    require 'pg'
    config = ROM::Configuration.new(:sql, 'postgres://postgres:password@localhost:5432/sample_db')
    register('db.config', config)
  end
end
