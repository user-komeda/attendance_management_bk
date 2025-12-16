# frozen_string_literal: true

# rbs_inline: enabled

module Presentation
  module Controller
    module Auth
      class AuthController < AuthControllerBase
        # @rbs (Hash[Symbol, untyped] params) -> Hash[Symbol, String]
        def signup(params)
          signup_request = build_request(params, SIGNUP_REQUEST)
          response = invoke_use_case(:signup, signup_request.convert_to_dto)
          AUTH_RESPONSE.build(id: response.id, user_id: response.user_id)
        end

        # @rbs (Hash[Symbol, untyped] params) -> Hash[Symbol, String]
        # def signin(params)
        #   signin_request = build_request(params, SIGNIN_REQUEST)
        #   response = invoke_use_case(:signin, signin_request)
        #   AUTH_RESPONSE.build(id: response.id, user_id: response.user_id)
        # end
      end
    end
  end
end
