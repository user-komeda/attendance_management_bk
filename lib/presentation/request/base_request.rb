# frozen_string_literal: true

# rbs_inline: enabled

module Presentation
  module Request
    class BaseRequest

      protected

      # @rbs () -> ::Application::Dto::InputBaseDto
      def convert_to_dto
        raise NotImplementedError
      end

      # @rbs (Hash[Symbol, untyped] params) -> BaseRequest
      def self.build(params)
        raise NotImplementedError
      end

      # @rbs (Hash[Symbol, untyped] params) -> void
      def self.validate(params)
        raise NotImplementedError
      end
    end
  end
end