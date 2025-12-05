# frozen_string_literal: true

# rbs_inline: enabled

module Presentation
  module Controller
    module User
      class UserControllerBase < Presentation::Controller::ControllerBase
        # @rbs USER_USE_CASE: Constant::ContainerKey::ApplicationKey::USER_USE_CASE
        USER_USE_CASE = Constant::ContainerKey::ApplicationKey::USER_USE_CASE.freeze
        # @rbs RESPONSE: ::Presentation::Response::User::UserResponse
        RESPONSE = ::Presentation::Response::User::UserResponse.freeze
        # @rbs BASE_REQUEST: ::Presentation::Request::User::UserBaseRequest
        BASE_REQUEST = ::Presentation::Request::User::UserBaseRequest.freeze
        # @rbs CREATE_REQUEST: ::Presentation::Request::User::CreateUserRequest
        CREATE_REQUEST = ::Presentation::Request::User::CreateUserRequest.freeze
        # @rbs UPDATE_REQUEST: ::Presentation::Request::User::UpdateUserRequest
        UPDATE_REQUEST = ::Presentation::Request::User::UpdateUserRequest.freeze

        protected

        # @rbs (Hash[Symbol, untyped] request_payload, untyped request_class) -> ::Presentation::Request::User::UserBaseRequest
        def build_request(request_payload, request_class)
          raise ArgumentError, "#{request_class} is not a valid User request class" unless request_class <= BASE_REQUEST

          request_class.build(request_payload)
        end

        # @rbs (Symbol key, *untyped args) -> untyped
        def invoke_use_case(key, *args)
          key = USER_USE_CASE[key].key
          invoker = resolve(key)
          invoker.invoke(*args)
        end
      end
    end
  end
end
