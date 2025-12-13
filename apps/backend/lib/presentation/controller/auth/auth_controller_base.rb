# frozen_string_literal: true

# rbs_inline: enabled

module Presentation
  module Controller
    module Auth
      class AuthControllerBase < ControllerBase
        AUTH_USE_CASE = Constant::ContainerKey::ApplicationKey::AUTH_USE_CASE.freeze
        AUTH_RESPONSE = ::Presentation::Response::Auth::AuthResponse.freeze
        BASE_REQUEST = ::Presentation::Request::Auth::AuthBaseRequest.freeze
        # SIGNIN_REQUEST = ::Presentation::Request::Auth::SigninRequest.freeze
        SIGNUP_REQUEST = ::Presentation::Request::Auth::SignupRequest.freeze

        protected

        # @rbs (Hash[Symbol, untyped] request_payload, untyped request_class) -> ::Presentation::Request::Auth::AuthBaseRequest
        def build_request(request_payload, request_class)
          unless request_class <= BASE_REQUEST
            raise ArgumentError,
                  "#{request_class} is not a valid User request class"
          end

          request_class.build(request_payload)
        end

        # @rbs (Symbol key, *untyped args) -> untyped
        def invoke_use_case(key, *)
          key = AUTH_USE_CASE[key].key
          invoker = resolve(key)
          invoker.invoke(*)
        end
      end
    end
  end
end
