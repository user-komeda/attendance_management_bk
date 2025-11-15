# frozen_string_literal: true

# rbs_inline: enabled

module Constant
  module Errors
    module Codes
      # @rbs BAD_REQUEST: Symbol
      BAD_REQUEST      = :bad_request

      # @rbs NOT_FOUND: Symbol
      NOT_FOUND        = :not_found

      # @rbs DUPLICATE: Symbol
      DUPLICATE        = :duplicate

      # @rbs ALREADY_DELETED: Symbol
      ALREADY_DELETED  = :already_deleted
    end

    module Status
      # @rbs MAP: Hash[Symbol, Integer]
      MAP = {
        Codes::BAD_REQUEST => 400,
        Codes::NOT_FOUND => 404,
        Codes::DUPLICATE => 409,
        Codes::ALREADY_DELETED => 409
      }.freeze
    end
  end
end
