# frozen_string_literal: true

module Application
  module UseCase
    class BaseUseCase
      include ContainerHelper
      def invoke
        raise NotImplementedError
      end
    end
  end
end
