# frozen_string_literal: true

# :nocov:

module VerifyJwt
  extend ContainerHelper

  PUBLIC_PATH = %w[/swagger /swagger/token /health /openapi].freeze
  BFF_JWT_PATH = %w[/signin /signup].freeze

  def self.skip_jwt_verification?(path)
    PUBLIC_PATH.include?(path) || path.start_with?('/openapi/')
  end

  def self.bff_jwt_verification?(path)
    BFF_JWT_PATH.include?(path)
  end

  def self.verify_user_jwt(token)
    if ENV['RACK_ENV'] == 'test'
      return Struct.new(:user_id).new('04e8496c-6b8c-4f4f-9746-2d96a10f13ec') if token.nil?

      begin
        return verify_jwt(token, type: :user)
      rescue StandardError => _e
        return Struct.new(:user_id).new(token)
      end
    end

    verify_jwt(token, type: :user)
  end

  def self.verify_bff_jwt(token)
    return if ENV['RACK_ENV'] == 'test'

    verify_jwt(token, type: :bff)
  end

  def self.verify_jwt(token, type:)
    raise Application::Exception::AuthenticationFailedException.new(message: 'missing bearer token') if token.nil?

    key = Constant::ContainerKey::ApplicationKey::AUTH_USE_CASE[:verify_jwt].key
    invoker = resolve(key)
    invoker.invoke(token: token, type: type)
  end

  def self.parse_bearer_token(bearer)
    return nil unless bearer&.start_with?('Bearer ')

    bearer.split(' ', 2)[1]
  end
end
# :nocov:
