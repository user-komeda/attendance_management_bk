# frozen_string_literal: true

# rbs_inline: enabled

module Application
  module Exception
    class UserNotFoundFromSub < AppException::ApiError
      # @rbs (message: String) -> void
      def initialize(message:)
        super(message: message, error_code: Constant::Errors::Codes::USER_NOT_FOUND_FROM_SUB)
      end
    end
  end
end
