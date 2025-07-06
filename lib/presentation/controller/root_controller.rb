# frozen_string_literal: true
require_relative '../../../config/import'
require_relative '../../../config/container_key'
require_relative '../../../helper/container_helper'
module Controller
  class RootController
    include ContainerHelper
    include AutoInject[ContainerKey::ApplicationKey.key(:ROOT_USE_CASE)]

    def index
      key = ContainerKey::ApplicationKey.key(:ROOT_USE_CASE)
      invoker = resolve(key)
      invoker.invoke
      { message: "hello_world" }.to_json
    end
  end
end
