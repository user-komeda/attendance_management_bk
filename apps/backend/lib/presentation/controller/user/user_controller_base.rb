# frozen_string_literal: true

# rbs_inline: enabled

module Presentation
  module Controller
    module User
      class UserControllerBase < Presentation::Controller::ControllerBase
        USER_USE_CASE = Constant::ContainerKey::ApplicationKey::USER_USE_CASE.freeze
        USE_CASE_CONTAINER = USER_USE_CASE
        RESPONSE = ::Presentation::Response::User::UserResponse.freeze
        BASE_REQUEST = ::Presentation::Request::User::UserBaseRequest.freeze
        CREATE_REQUEST = ::Presentation::Request::User::CreateUserRequest.freeze
        UPDATE_REQUEST = ::Presentation::Request::User::UpdateUserRequest.freeze
      end
    end
  end
end
