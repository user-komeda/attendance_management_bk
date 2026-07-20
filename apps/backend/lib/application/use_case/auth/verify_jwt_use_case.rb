# frozen_string_literal: true

# rbs_inline: enabled

require 'jwt'
module Application
  module UseCase
    module Auth
      class VerifyJwtUseCase < AuthBaseUseCase
        JWT_ALGORITHM = 'HS256'

        def invoke(token:, type:)
          payload = decode_and_validate_payload(token, type)
          return true if type == :bff

          user_id = payload['sub']
          user_id_str = user_id.to_s
          ::Application::Dto::Auth::AuthOutputDto.build(id: user_id_str, user_id: user_id_str)
        rescue JWT::DecodeError
          raise Exception::InvalidToken.new(message: 'invalid token')
        end

        private

        def decode_and_validate_payload(token, type)
          payload, = JWT.decode(
            token,
            secret_for(type),
            true,
            decode_options
          )

          validate_payload(payload, type)

          payload
        end

        def decode_options
          app_env = AppEnv.get

          {
            algorithm: JWT_ALGORITHM,
            iss: app_env['JWT_ISSUER'],
            verify_iss: true,
            aud: app_env['JWT_AUDIENCE'],
            verify_aud: true
          }
        end

        def secret_for(type)
          app_env = AppEnv.get

          {
            user: app_env['JWT_SECRET'],
            bff: app_env['BFF_JWT_SECRET']
          }.fetch(type) { raise Exception::InvalidToken.new(message: 'invalid token type') }
        end

        def validate_payload(payload, type)
          validate_expiration(payload['exp'])
          validate_type(payload, type)
        end

        def validate_expiration(exp_val)
          exp = exp_val&.to_i
          raise Exception::InvalidToken.new(message: 'missing exp') unless exp&.positive?
          raise Exception::TokenExpired.new(message: 'token expired') if exp <= Time.now.to_i
        end

        def validate_type(payload, type)
          typ = payload['typ']
          validator_for(type).call(payload: payload, typ: typ)
        end

        def validator_for(type)
          {
            user: ->(payload:, typ:) { validate_user_token!(payload: payload, typ: typ) },
            bff: ->(payload:, typ:) { validate_bff_token!(payload: payload, typ: typ) }
          }.fetch(type) { raise Exception::InvalidToken.new(message: 'invalid token type') }
        end

        def validate_user_token!(payload:, typ:)
          return if typ == 'access_token' && !payload['sub'].to_s.empty?

          raise Exception::InvalidToken.new(message: 'invalid user token')
        end

        def validate_bff_token!(payload:, typ:)
          raise Exception::InvalidToken.new(message: 'invalid bff token') unless payload.is_a?(Hash)

          return if typ == 'bff_assertion'

          raise Exception::InvalidToken.new(message: 'invalid bff token')
        end
      end
    end
  end
end
