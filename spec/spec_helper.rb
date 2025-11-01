# frozen_string_literal: true

require 'rack/test'
require 'rspec'
require 'json'
require 'rom'
require 'rackup' # 縺薙・陦後ｒ霑ｽ蜉


ENV['RACK_ENV'] = 'test'

# 繝励Ο繧ｸ繧ｧ繧ｯ繝医Ν繝ｼ繝医・險ｭ螳・
ROOT_DIR = File.expand_path('..', __dir__)
$LOAD_PATH.unshift(File.join(ROOT_DIR, 'lib')) unless $LOAD_PATH.include?(File.join(ROOT_DIR, 'lib'))
$LOAD_PATH.unshift(File.join(ROOT_DIR, 'helper')) unless $LOAD_PATH.include?(File.join(ROOT_DIR, 'helper'))

# Zeitwerk縺ｫ繧医ｋ繧ｪ繝ｼ繝医Ο繝ｼ繝峨ｒ譛牙柑蛹・
require File.join(ROOT_DIR, 'config', 'auto_load')

RSpec.configure do |config|
  config.include Rack::Test::Methods
end

# Rack::Test 縺悟他縺ｳ蜃ｺ縺吶い繝励Μ繧偵％縺薙〒謖・ｮ・
def app
  result = Rack::Builder.parse_file('config.ru')
  # parse_file縺ｯ驟榊・繧定ｿ斐☆蝣ｴ蜷医→逶ｴ謗･繧｢繝励Μ繧定ｿ斐☆蝣ｴ蜷医′縺ゅｋ
  result.is_a?(Array) ? result.first : result
end