# frozen_string_literal: true

module Application
  module Exception
    class DuplicatedException < ::AppException::ApiError
      def initialize(message:)
        super(
          message: message,
          error_code: Constant::Errors::Codes::DUPLICATE,
          status_code: Constant::Errors::Status::MAP[Constant::Errors::Codes::DUPLICATE])
      end
    end
  end
end
