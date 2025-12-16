# frozen_string_literal: true

# rbs_inline: enabled

module Domain
  module Exception
    class InvalidPasswordError < ::AppException::ApiError
      # @rbs (message: String) -> void
      def initialize(message:)
        super(message: message,
              error_code: Constant::Errors::Codes::INVALID_PASSWORD)
      end
    end
  end
end
