# frozen_string_literal: true

module SinatraErrorHandler
  include ResponseHelper

  def self.registered(app)
    app.error AppException::ApiError do
      handle_api_error(env['sinatra.error'])
    end

    app.error StandardError do
      handle_standard_error(env['sinatra.error'])
    end
  end

  def handle_api_error(error)
    warn "[#{error.class}] #{error.message}"
    warn error.backtrace.join("\n") if error.backtrace

    respond_with_error(error)
  end

  def handle_standard_error(error)
    warn "[#{error.class}] #{error.message}"
    warn error.backtrace.join("\n") if error.backtrace

    api_error = AppException::ApiError.new(
      message: 'Internal server error',
      error_code: Constant::Errors::Codes::INTERNAL_SERVER_ERROR
    )

    respond_with_error(api_error)
  end
end
