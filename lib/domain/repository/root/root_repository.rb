# frozen_string_literal: true

module Domain
  module Repository
    module Root
      class RootRepository
        include ContainerHelper
        include AutoInject[ContainerKey::Repository.key(:REPOSITORY)]
        def get_all()
          key=ContainerKey::Repository.key(:REPOSITORY)
          caller=Container.resolve(key)
          caller.get_all
        end
      end
    end
  end
end
