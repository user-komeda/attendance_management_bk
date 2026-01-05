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

        # @rbs (request_payload: Hash[Symbol, untyped], request_class: untyped) -> ::Presentation::Request::User::UserBaseRequest
        def build_request(request_payload, request_class)
          raise ArgumentError, "#{request_class} is not a valid User request class" unless request_class <= BASE_REQUEST

          request_class.build(params: request_payload)
        end

        # @rbs [T] (key: Symbol, *untyped args) -> T
        def invoke_use_case(key, *args)
          key = USER_USE_CASE[key].key
          invoker = resolve(key)
          # : Hash[Symbol, untyped]
          params = if UtilMethod.nil_or_empty?(args)
                     {} # : Hash[Symbol, untyped]
                   else
                     { args: args.first }
                   end
          invoker.invoke(**params)
        end
      end
    end
  end
end
