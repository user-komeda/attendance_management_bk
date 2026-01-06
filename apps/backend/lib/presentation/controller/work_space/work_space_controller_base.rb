# frozen_string_literal: true

# rbs_inline: enabled

module Presentation
  module Controller
    module WorkSpace
      class WorkSpaceControllerBase < Presentation::Controller::ControllerBase
        WORK_SPACE_USE_CASE = Constant::ContainerKey::ApplicationKey::WORK_SPACE_USE_CASE.freeze
        WORK_SPACE_RESPONSE = ::Presentation::Response::WorkSpace::WorkSpaceResponse.freeze
        MEMBER_SHIPS_RESPONSE = ::Presentation::Response::WorkSpace::MemberShipsResponse.freeze
        WORK_SPACE_WITH_STATUS_RESPONSE = ::Presentation::Response::WorkSpace::WorkSpaceWithStatusResponse.freeze
        WORK_SPACE_WITH_MEMBER_SHIPS_RESPONSE = ::Presentation::Response::WorkSpace::WorkSpaceWithMemberShipsResponse.freeze
        BASE_REQUEST = ::Presentation::Request::WorkSpace::WorkSpaceBaseRequest.freeze
        CREATE_REQUEST = ::Presentation::Request::WorkSpace::CreateWorkSpaceRequest.freeze
        UPDATE_REQUEST = ::Presentation::Request::WorkSpace::UpdateWorkSpaceRequest.freeze

        # @rbs (Hash[Symbol, untyped] request_payload, untyped request_class) -> ::Presentation::Request::WorkSpace::WorkSpaceBaseRequest
        def build_request(request_payload, request_class)
          raise ArgumentError, "#{request_class} is not a valid User request class" unless request_class <= BASE_REQUEST

          request_class.build(params: request_payload)
        end

        # @rbs [T] (Symbol key, *untyped args) -> T
        def invoke_use_case(key, *args)
          key = WORK_SPACE_USE_CASE[key].key
          invoker = resolve(key)
          # @type var params: Hash[Symbol, untyped]
          params = UtilMethod.nil_or_empty?(args) ? {} : { args: args.first }
          invoker.invoke(**params)
        end
      end
    end
  end
end
