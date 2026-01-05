# frozen_string_literal: true

# rbs_inline: enabled

module Application
  module Exception
    class TokenMisMatch < AppException::ApiError
      # @rbs (message: String) -> void
      def initialize(message:)
        super(message: message, error_code: Constant::Errors::Codes::TOKEN_MISMATCH)
      end
    end
  end
end
