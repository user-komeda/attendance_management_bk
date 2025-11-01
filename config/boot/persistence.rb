# frozen_string_literal: true

require_relative '../container'

Container.register_provider(:persistence) do |_app|
  start do
    config = Container.resolve('db.config')

    # 繝ｪ繝ｬ繝ｼ繧ｷ繝ｧ繝ｳ縺ｪ縺ｩ縺ｮ逋ｻ骭ｲ繧医ｊ蜑阪↓繝励Λ繧ｰ繧､繝ｳ繧呈怏蜉ｹ縺ｫ縺吶ｋ
    # 閾ｪ蜍慕匳骭ｲ繧貞ｮ溯｡・    config.auto_registration(Pathname.new(__dir__).join('../../lib/infrastructure').realpath, namespace: true)

    # 逋ｻ骭ｲ貂医∩縺ｮconfig繧ｪ繝悶ず繧ｧ繧ｯ繝医ｒROM.container縺ｫ貂｡縺・    register('container', ROM.container(config))
  end
end
