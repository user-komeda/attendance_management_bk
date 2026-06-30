# frozen_string_literal: true

require 'dry/system'
require_relative 'container_inflector'

class Container < Dry::System::Container
  configure do |config|
    config.root = Pathname('.')

    config.inflector = ContainerInflector.new

    config.component_dirs.loader = Dry::System::Loader::Autoloading

    config.component_dirs.add 'lib'
  end
end
