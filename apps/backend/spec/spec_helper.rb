# frozen_string_literal: true

require 'rack/test'
require 'rspec'
require 'json'
require 'rom'
require 'rackup'
require 'simplecov'
SimpleCov.start do
  enable_coverage :branch
  add_filter do |source_file|
    source_file.filename.include?('base') || source_file.filename.include?('spec')
  end
end

ENV['RACK_ENV'] = 'test'

ROOT_DIR = File.expand_path('..', __dir__)
$LOAD_PATH.unshift(File.join(ROOT_DIR, 'lib')) unless $LOAD_PATH.include?(File.join(ROOT_DIR, 'lib'))
$LOAD_PATH.unshift(File.join(ROOT_DIR, 'helper')) unless $LOAD_PATH.include?(File.join(ROOT_DIR, 'helper'))

require File.join(ROOT_DIR, 'config', 'auto_load')

RSpec.configure do |config|
  config.include Rack::Test::Methods
end

def app
  result = Rack::Builder.parse_file('config.ru')
  result.is_a?(Array) ? result.first : result
end
