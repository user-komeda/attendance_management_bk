# frozen_string_literal: true
module Domain
  module Service
    module Root
      class RootService
        include ContainerHelper
        include AutoInject[ContainerKey::DomainRepository.key(:DOMAIN_REPOSITORY)]

        def get_all
          key = ContainerKey::DomainRepository.key(:DOMAIN_REPOSITORY)
          caller=Container.resolve(key)
          caller.get_all
        end
      end
    end
  end
end
