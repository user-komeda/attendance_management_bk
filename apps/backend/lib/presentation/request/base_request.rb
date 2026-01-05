# frozen_string_literal: true

# rbs_inline: enabled

module Presentation
  module Request
    class BaseRequest
      # @rbs () -> ::Application::Dto::InputBaseDto
      def convert_to_dto
        raise NotImplementedError
      end


      class << self
        # @rbs (Hash[Symbol, untyped] params) -> BaseRequest
        def build(params)
          raise NotImplementedError
        end

        # @rbs (Hash[Symbol, untyped] params) -> void
        def validate(params)
          raise NotImplementedError
        end
      end
    end
  end
end
