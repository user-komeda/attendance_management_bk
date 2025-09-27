# frozen_string_literal: true

module Constant
  module Errors
    module Codes
      BAD_REQUEST      = :bad_request
      NOT_FOUND        = :not_found
      DUPLICATE        = :duplicate
      ALREADY_DELETED  = :already_deleted
    end

    module Status
      MAP = {
        Codes::BAD_REQUEST => 400,
        Codes::NOT_FOUND => 404,
        Codes::DUPLICATE => 409,
        Codes::ALREADY_DELETED => 409
      }.freeze
    end
  end
end
