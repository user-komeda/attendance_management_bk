# frozen_string_literal: true

require_relative '../container'

Container.register_provider(:persistence) do |_app|
  start do
    config = Container.resolve('db.config')

    # リレーションなどの登録より前にプラグインを有効にする
    # 自動登録を実行
    config.auto_registration(Pathname.new(__dir__).join('../../lib/infrastructure').realpath, namespace: true)

    # 登録済みのconfigオブジェクトをROM.containerに渡す
    register('container', ROM.container(config))
  end
end
