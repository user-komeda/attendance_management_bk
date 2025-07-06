# frozen_string_literal: true
require_relative '../../../../config/import'
require_relative '../../../../config/container_key'
require_relative '../../../../helper/container_helper'

module Application
  module UseCase
    module Root
      class GetAllUseCase
        include ContainerHelper
        include AutoInject[ContainerKey::ServiceKey.key(:ROOT_SERVICE)]

        def invoke
          key = ContainerKey::ServiceKey.key(:ROOT_SERVICE)
          caller = Container.resolve(key)
          method = ContainerKey::ServiceKey.method(:ROOT_SERVICE, :get_all)
          caller.send(method)
        end
      end
    end
  end
end

