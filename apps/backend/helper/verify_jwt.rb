# frozen_string_literal: true

# :nocov:

module VerifyJwt
  extend ContainerHelper

  PUBLIC_PATH = %w[/signin /signup].freeze

  def self.skip_jwt_verification?(path)
    PUBLIC_PATH.include?(path)
  end

  def self.verify_jwt(token)
    raise Application::Exception::AuthenticationFailedException.new(message: 'missing bearer token') if token.nil?

    key = Constant::ContainerKey::ApplicationKey::AUTH_USE_CASE[:verify_jwt].key
    invoker = resolve(key)
    invoker.invoke(token)
  end

  def self.parse_bearer_token(bearer)
    return nil unless bearer&.start_with?('Bearer ')

    bearer.split(' ', 2)[1]
  end
end
# :nocov:
