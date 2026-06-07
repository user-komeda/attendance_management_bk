# frozen_string_literal: true

# rbs_inline: enabled

module Presentation
  module Exception
    class BadRequestException < ::AppException::ApiError
      # @rbs (?message: String, ?field_errors: Array[{ key: String, message: String }]?) -> void
      def initialize(message: 'Bad Request', field_errors: nil)
        super(
          message: message,
          error_code: Constant::Errors::Codes::BAD_REQUEST,
          field_errors: field_errors,
        )
      end
    end
  end
end
