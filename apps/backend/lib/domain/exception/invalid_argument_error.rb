# frozen_string_literal: true

# rbs_inline: enabled

module Domain
  module Exception
    class InvalidArgumentError < ::AppException::ApiError
      # @rbs (message: String) -> void
      def initialize(message:)
        super(message: message,
              error_code: Constant::Errors::Codes::BAD_REQUEST)
      end
    end
  end
end
