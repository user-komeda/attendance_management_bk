# frozen_string_literal: true

module AppException
  class ApiError < StandardError
    attr_reader :status_code, :error_code

    def initialize(message:, status_code:, error_code:)
      super(message)
      @status_code = status_code
      @error_code = error_code
    end
  end
end
