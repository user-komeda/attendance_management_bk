# frozen_string_literal: true

module Presentation
  module Exception
    class BadRequestException < ::AppException::ApiError
      def initialize(message:)
        super(message: message,
              error_code: Constant::Errors::Codes::BAD_REQUEST,
              status_code: Constant::Errors::Status::MAP[Constant::Errors::Codes::BAD_REQUEST])
      end
    end
  end
end
