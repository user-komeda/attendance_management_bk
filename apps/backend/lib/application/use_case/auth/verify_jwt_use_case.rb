# frozen_string_literal: true

# # frozen_string_literal: true
#
# # rbs_inline: enabled
#
# require 'jwt'
# module Application
#   module UseCase
#     module Auth
#       class VerifyJwtUseCase < AuthBaseUseCase
#         def invoke(token)
#           sub, jti, sv = decode_and_validate_payload(token)
#
#           user_id = verify_token_in_redis(jti, sub)
#
#           user = fetch_user(user_id)
#           verify_session_version(user, sv)
#
#           AuthOutputDto.build(id: user_id, user_id: user_id)
#         rescue JWT::DecodeError
#           raise Exception::InvalidToken
#         end
#
#         private
#
#         def decode_and_validate_payload(token)
#           payload, = JWT.decode(token, ENV.fetch('JWT_SECRET', nil), true, algorithm: 'HS256')
#           exp, sub, jti, session_version = extract_claims(payload)
#
#           validate_claims(exp, sub, jti, session_version)
#
#           [exp, sub, jti, session_version]
#         end
#
#         def extract_claims(payload)
#           %w[exp sub jti sv].map do |k|
#             v = payload[k]
#             k == 'jti' ? v : v&.to_i
#           end
#         end
#
#         def validate_claims(exp, sub, jti, session_version)
#           validate_presence(exp, sub, jti, session_version)
#           validate_expiration(exp)
#         end
#
#         def validate_presence(exp, sub, jti, session_version)
#           raise Exception::InvalidToken unless exp&.positive? && sub&.positive? && jti && session_version&.positive?
#         end
#
#         def validate_expiration(exp)
#           raise Exception::TokenExpired if exp <= Time.now.to_i
#         end
#
#         def verify_token_in_redis(jti, sub)
#           user_id = RedisHelper.redis_get(jti)&.to_i
#
#           raise Exception::TokenRevoked unless user_id&.positive?
#           raise Exception::TokenMisMatch if user_id != sub&.to_i
#
#           user_id
#         end
#
#         def fetch_user(user_id)
#           repository = resolve(USER_REPOSITORY_KEY)
#           user = repository.get_by_id(user_id)
#           raise Exception::UserNotFoundFromSub unless user
#
#           user
#         end
#
#         def verify_session_version(user, payload_sv)
#           raise Exception::SessionVersionMisMatch unless user.session_version&.to_i == payload_sv&.to_i
#         end
#       end
#     end
#   end
# end
