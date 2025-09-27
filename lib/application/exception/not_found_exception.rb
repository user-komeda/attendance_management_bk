# frozen_string_literal: true

module Application
  module Exception
    class NotFoundException < ::AppException::ApiError
      def initialize(message:)
        super(message: message,
              error_code: Constant::Errors::Codes::NOT_FOUND,
              status_code: Constant::Errors::Status::MAP[Constant::Errors::Codes::NOT_FOUND])
      end
    end
  end
end
