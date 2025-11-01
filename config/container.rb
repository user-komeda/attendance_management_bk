# frozen_string_literal: true

require 'dry/system'

class Container < Dry::System::Container
  configure do |config|
    config.root = Pathname('.')

    config.component_dirs.loader = Dry::System::Loader::Autoloading

    config.component_dirs.add 'lib'
  end
end
