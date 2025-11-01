# frozen_string_literal: true

# Rakefile
require 'rake'
require_relative 'config/auto_load'
require 'dotenv/load'

ENV['RACK_ENV'] ||= 'local'
# lib/tasks 以下の rake タスクを全て読み込む
Dir.glob('tasks/**/*.rake').sort.each { |file| load file }
