# frozen_string_literal: true

# rbs_inline: enabled

module Application
  module Exception
    class SessionVersionMisMatch < AppException::ApiError
      # @rbs (message: String) -> void
      def initialize(message:)
        super(message: message, error_code: Constant::Errors::Codes::SESSION_VERSION_MISMATCH)
      end
    end
  end
end
