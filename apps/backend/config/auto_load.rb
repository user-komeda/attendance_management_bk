# frozen_string_literal: true

require 'zeitwerk'
require_relative 'container'

loader = Zeitwerk::Loader.new
loader.push_dir(Container.config.root.join('lib').realpath)
loader.push_dir(Container.config.root.join('helper').realpath)
loader.setup
