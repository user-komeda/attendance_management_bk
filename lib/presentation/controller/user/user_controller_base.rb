# frozen_string_literal: true

module Presentation
  module Controller
    module User
      class UserControllerBase < Presentation::Controller::ControllerBase
        USER_USE_CASE = Constant::ContainerKey::ApplicationKey::USER_USE_CASE.freeze
        RESPONSE = ::Presentation::Response::User::UserResponse.freeze
        BASE_REQUEST = ::Presentation::Request::User::UserBaseRequest
        CREATE_REQUEST = ::Presentation::Request::User::CreateUserRequest.freeze
        UPDATE_REQUEST = ::Presentation::Request::User::UpdateUserRequest.freeze

        protected

        def build_request(request_payload, request_class)
          raise ArgumentError, "#{request_class} is not a valid User request class" unless request_class <= BASE_REQUEST

          request_class.build(request_payload)
        end

        def invoke_use_case(key, *args)
          key = USER_USE_CASE[key].key
          invoker = resolve(key)
          invoker.invoke(*args)
        end
      end
    end
  end
end
