# frozen_string_literal: true

# rbs_inline: enabled

module Presentation
  module Request
    class BaseRequest
      ABSTRACT_ERROR_MESSAGE = 'Subclasses must implement this method'

      # @rbs () -> ::Application::Dto::InputBaseDto
      def convert_to_dto
        raise NotImplementedError, ABSTRACT_ERROR_MESSAGE
      end

      class << self
        # @rbs (Hash[Symbol, untyped] params) -> BaseRequest
        def build(params)
          raise NotImplementedError, ABSTRACT_ERROR_MESSAGE
        end

        # @rbs (Hash[Symbol, untyped] params) -> void
        def validate(params)
          raise NotImplementedError, ABSTRACT_ERROR_MESSAGE
        end

        # @rbs (contract: untyped, params: Hash[Symbol, untyped]) -> void
        def validate_or_raise!(contract:, params:)
          result = contract_result(contract: contract, params: params)
          return unless result.failure?

          raise ::Presentation::Exception::BadRequestException.new(message: contract_error_message(result: result))
        end

        private

        # @rbs (contract: untyped, params: Hash[Symbol, untyped]) -> untyped
        def contract_result(contract:, params:)
          contract.new.call(params)
        end

        # @rbs (result: untyped) -> String
        def contract_error_message(result:)
          result.errors.to_h.to_json
        end
      end
    end
  end
end
