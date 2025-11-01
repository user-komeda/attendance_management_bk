# frozen_string_literal: true

# rbs_inline: enabled

module Presentation
  module Exception
    class BadRequestException < ::AppException::ApiError
      # @rbs (message: String) -> void
      def initialize(message:)
        super(message: message,
              error_code: Constant::Errors::Codes::BAD_REQUEST,
              status_code: Constant::Errors::Status::MAP[Constant::Errors::Codes::BAD_REQUEST])
      end
    end
  end
end