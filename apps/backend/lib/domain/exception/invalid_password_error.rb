# frozen_string_literal: true

# rbs_inline: enabled

module Domain
  module Exception
    class InvalidPasswordError < ::AppException::ApiError
      # @rbs (message: String, field_errors: untyped) -> void
      def initialize(message:, field_errors:)
        super(message: message,
              error_code: Constant::Errors::Codes::INVALID_PASSWORD,
              field_errors: field_errors)
      end
    end
  end
end
