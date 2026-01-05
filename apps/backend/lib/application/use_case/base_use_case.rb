# frozen_string_literal: true

# rbs_inline: enabled

module Application
  module UseCase
    class BaseUseCase
      include ContainerHelper

      # @rbs (input_dto: ::Application::Dto::InputBaseDto | String | nil) -> ::Application::Dto::BaseDto
      def invoke(input_dto: nil)
        raise NotImplementedError
      end
    end
  end
end
