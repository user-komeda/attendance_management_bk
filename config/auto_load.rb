# frozen_string_literal: true

require_relative 'container'
require 'zeitwerk'

loader = Zeitwerk::Loader.new
loader.push_dir(Container.config.root.join('lib').realpath)
loader.push_dir(Container.config.root.join('config').realpath)
loader.setup