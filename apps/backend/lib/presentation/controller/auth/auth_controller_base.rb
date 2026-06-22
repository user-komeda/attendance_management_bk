# frozen_string_literal: true

# rbs_inline: enabled

module Presentation
  module Controller
    module Auth
      class AuthControllerBase < ControllerBase
        AUTH_USE_CASE = Constant::ContainerKey::ApplicationKey::AUTH_USE_CASE.freeze
        USE_CASE_CONTAINER = AUTH_USE_CASE
        AUTH_RESPONSE = ::Presentation::Response::Auth::AuthResponse.freeze
        BASE_REQUEST = ::Presentation::Request::Auth::AuthBaseRequest.freeze
        SIGNUP_REQUEST = ::Presentation::Request::Auth::SignupRequest.freeze
        SIGNIN_REQUEST = ::Presentation::Request::Auth::SigninRequest.freeze
      end
    end
  end
end
