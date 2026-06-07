# frozen_string_literal: true

# rbs_inline: enabled

require 'jwt'
module Application
  module UseCase
    module Auth
      class VerifyJwtUseCase < AuthBaseUseCase
        def invoke(token:, type:)
          payload = decode_and_validate_payload(token, type)
          return true if type == :bff

          user_id = payload['sub']
          ::Application::Dto::Auth::AuthOutputDto.build(id: user_id.to_s, user_id: user_id.to_s)
        rescue JWT::DecodeError
          raise Exception::InvalidToken.new(message: 'invalid token')
        end

        private

        def decode_and_validate_payload(token, type)
          payload, = JWT.decode(
            token,
            secret_for(type),
            true,
            {
              algorithm: 'HS256',
              iss: AppEnv.get['JWT_ISSUER'],
              verify_iss: true,
              aud: AppEnv.get['JWT_AUDIENCE'],
              verify_aud: true
            }
          )

          validate_payload(payload, type)

          payload
        end

        def secret_for(type)
          case type
          when :user
            AppEnv.get['JWT_SECRET']
          when :bff
            AppEnv.get['BFF_JWT_SECRET']
          else
            raise Exception::InvalidToken.new(message: 'invalid token type')
          end
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
          case type
          when :user
            unless typ == 'access_token' && !payload['sub'].to_s.empty?
              raise Exception::InvalidToken.new(message: 'invalid user token')
            end
          when :bff
            raise Exception::InvalidToken.new(message: 'invalid bff token') unless typ == 'bff_assertion'
          else
            raise Exception::InvalidToken.new(message: 'invalid token type')
          end
        end
      end
    end
  end
end
