# frozen_string_literal: true

# rbs_inline: enabled

module Application
  module Exception
    class TokenRevoked < AppException::ApiError
      # @rbs (message: String) -> void
      def initialize(message:)
        super(message: message, error_code: Constant::Errors::Codes::TOKEN_REVOKED)
      end
    end
  end
end
