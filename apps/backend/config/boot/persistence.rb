# frozen_string_literal: true

require_relative '../container'

Container.register_provider(:persistence) do |_app|
  start do
    config = Container.resolve('db.config')

    config.auto_registration(Pathname.new(__dir__).join('../../lib/infrastructure').realpath, namespace: true)

    register('container', ROM.container(config))
  end
end
