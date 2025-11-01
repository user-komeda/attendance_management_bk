# frozen_string_literal: true

# rbs_inline: enabled

module Application
  module UseCase
    class BaseUseCase
      include ContainerHelper

      # @rbs (::Application::Dto::InputBaseDto | String | nil arg) -> ::Application::Dto::BaseDto
      def invoke(arg = nil)
        raise NotImplementedError
      end
    end
  end
end