# frozen_string_literal: true

# rbs_inline: enabled

module Presentation
  module Request
    module Auth
      class AuthBaseRequest < BaseRequest
        SIGNIN_INPUT_DTO = ::Application::Dto::Auth::SigninInputDto.freeze
        SIGNUP_INPUT_DTO = ::Application::Dto::Auth::SignupInputDto.freeze
        SIGNIN_CONTRACT = ::Presentation::Request::Contract::Auth::SigninContract
        SIGNUP_CONTRACT = ::Presentation::Request::Contract::Auth::SignupContract
      end
    end
  end
end
