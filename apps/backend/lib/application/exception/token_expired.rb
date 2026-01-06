# frozen_string_literal: true

# rbs_inline: enabled

module Application
  module Exception
    class TokenExpired < AppException::ApiError
      # @rbs (message: String) -> void
      def initialize(message:)
        super(message: message, error_code: Constant::Errors::Codes::TOKEN_EXPIRED)
      end
    end
  end
end
