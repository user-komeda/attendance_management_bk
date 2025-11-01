
# frozen_string_literal: true

# rbs_inline: enabled

module AppException
  class ApiError < StandardError
    # @rbs @status_code: Symbol
    # @rbs @error_code: Symbol
    attr_reader :status_code, :error_code

    # @rbs (message: String, status_code: Symbol, error_code: Symbol) -> void
    def initialize(message:, status_code:, error_code:)
      super(message)
      @status_code = status_code
      @error_code = error_code
    end
  end
end