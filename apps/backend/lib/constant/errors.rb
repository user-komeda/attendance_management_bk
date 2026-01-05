# frozen_string_literal: true

# rbs_inline: enabled

module Constant
  module Errors
    module Codes
      BAD_REQUEST = :bad_request

      NOT_FOUND = :not_found

      DUPLICATE = :duplicate

      ALREADY_DELETED = :already_deleted
      INVALID_PASSWORD = :invalid_password
      UNAUTHENTICATED = :unauthenticated
      TOKEN_EXPIRED = :token_expired
      INVALID_TOKEN = :invalid_token
      TOKEN_REVOKED = :token_revoked
      TOKEN_MISMATCH = :token_mismatch
      USER_NOT_FOUND_FROM_SUB = :user_not_found_from_sub
      SESSION_VERSION_MISMATCH = :session_version_mismatch
    end

    module Status
      # @rbs MAP: Hash[Symbol, Integer]
      MAP = {
        Codes::BAD_REQUEST => 400,
        Codes::UNAUTHENTICATED => 401,
        Codes::TOKEN_EXPIRED => 401,
        Codes::INVALID_TOKEN => 401,
        Codes::TOKEN_REVOKED => 401,
        Codes::TOKEN_MISMATCH => 401,
        Codes::INVALID_PASSWORD => 401,
        Codes::SESSION_VERSION_MISMATCH => 401,
        Codes::USER_NOT_FOUND_FROM_SUB => 401,
        Codes::NOT_FOUND => 404,
        Codes::DUPLICATE => 409,
        Codes::ALREADY_DELETED => 409
      }.freeze
    end
  end
end
