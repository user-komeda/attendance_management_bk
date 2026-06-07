# frozen_string_literal: true

# rbs_inline: enabled

module AppException
  class ApiError < StandardError
    # @rbs @status_code: Symbol
    # @rbs @error_code: Symbol
    # @rbs @field_errors: untyped
    attr_reader :status_code, :error_code, :field_errors

    # @rbs (message: String, error_code: Symbol, ?field_errors: untyped) -> void
    def initialize(message:, error_code:, field_errors: nil)
      super(message)
      @error_code = error_code
      @status_code = Constant::Errors::Status::MAP[error_code]
      @field_errors = field_errors
    end
  end
end
