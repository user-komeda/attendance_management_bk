# frozen_string_literal: true

module Application
  module UseCase
    module Root
      class GetUseCase
        include ContainerHelper
        include AutoInject[ContainerKey::ServiceKey.key(:ROOT_SERVICE)]
        def invoke
          puts("bbbb")
        end
      end
    end
  end
end

