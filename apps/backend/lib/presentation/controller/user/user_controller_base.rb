# frozen_string_literal: true

# rbs_inline: enabled

module Presentation
  module Controller
    module User
      class UserControllerBase < Presentation::Controller::ControllerBase
        USER_USE_CASE = Constant::ContainerKey::ApplicationKey::USER_USE_CASE.freeze
        RESPONSE = ::Presentation::Response::User::UserResponse.freeze
        BASE_REQUEST = ::Presentation::Request::User::UserBaseRequest.freeze
        CREATE_REQUEST = ::Presentation::Request::User::CreateUserRequest.freeze
        UPDATE_REQUEST = ::Presentation::Request::User::UpdateUserRequest.freeze

        protected

        # @rbs (Hash[Symbol, untyped] request_payload, untyped request_class) -> ::Presentation::Request::User::UserBaseRequest
        def build_request(request_payload, request_class)
          raise ArgumentError, "#{request_class} is not a valid User request class" unless request_class <= BASE_REQUEST

          request_class.build(request_payload)
        end

        # @rbs (Symbol key, *untyped args) -> untyped
        def invoke_use_case(key, *)
          key = USER_USE_CASE[key].key
          invoker = resolve(key)
          invoker.invoke(*)
        end
      end
    end
  end
end
