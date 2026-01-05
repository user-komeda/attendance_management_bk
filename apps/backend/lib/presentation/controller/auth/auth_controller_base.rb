# frozen_string_literal: true

# rbs_inline: enabled

module Presentation
  module Controller
    module Auth
      class AuthControllerBase < ControllerBase
        AUTH_USE_CASE = Constant::ContainerKey::ApplicationKey::AUTH_USE_CASE.freeze
        AUTH_RESPONSE = ::Presentation::Response::Auth::AuthResponse.freeze
        BASE_REQUEST = ::Presentation::Request::Auth::AuthBaseRequest.freeze
        SIGNUP_REQUEST = ::Presentation::Request::Auth::SignupRequest.freeze
        SIGNIN_REQUEST = ::Presentation::Request::Auth::SigninRequest.freeze

        protected

        # @rbs (Hash[Symbol, untyped] request_payload, untyped request_class) -> Presentation::Request::Auth::AuthBaseRequest
        def build_request(request_payload, request_class)
          unless request_class <= BASE_REQUEST
            raise ArgumentError,
                  "#{request_class} is not a valid User request class"
          end

          request_class.build(params: request_payload)
        end

        # @rbs [T] (Symbol key, *untyped args) -> T
        def invoke_use_case(key, *args)
          key = AUTH_USE_CASE[key].key
          invoker = resolve(key)
          # @type var params: Hash[Symbol, untyped]
          params = UtilMethod.nil_or_empty?(args) ? {} : { args: args.first }
          invoker.invoke(**params)
        end
      end
    end
  end
end
