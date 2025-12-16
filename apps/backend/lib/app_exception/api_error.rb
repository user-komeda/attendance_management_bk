# frozen_string_literal: true

# rbs_inline: enabled

module AppException
  class ApiError < StandardError
    # @rbs @status_code: Symbol
    # @rbs @error_code: Symbol
    attr_reader :status_code, :error_code

    # @rbs (message: String, error_code: Symbol) -> void
    def initialize(message:, error_code:)
      super(message)
      @error_code = error_code
      @status_code = Constant::Errors::Status::MAP[error_code]
    end
  end
end
