# frozen_string_literal: true

# rbs_inline: enabled

module Presentation
  module Controller
    module WorkSpace
      class WorkSpaceControllerBase < Presentation::Controller::ControllerBase
        WORK_SPACE_USE_CASE = Constant::ContainerKey::ApplicationKey::WORK_SPACE_USE_CASE.freeze
        USE_CASE_CONTAINER = WORK_SPACE_USE_CASE
        WORK_SPACE_PARAMS = ::Presentation::Params::WorkSpace::WorkSpaceParams.freeze
        WORK_SPACE_RESPONSE = ::Presentation::Response::WorkSpace::WorkSpaceResponse.freeze
        MEMBER_SHIPS_RESPONSE = ::Presentation::Response::WorkSpace::MemberShipsResponse.freeze
        WORK_SPACE_WITH_STATUS_RESPONSE = ::Presentation::Response::WorkSpace::WorkSpaceWithStatusResponse.freeze
        WORK_SPACE_WITH_MEMBER_SHIPS_RESPONSE = ::Presentation::Response::WorkSpace::WorkSpaceWithMemberShipsResponse.freeze
        BASE_REQUEST = ::Presentation::Request::WorkSpace::WorkSpaceBaseRequest.freeze
        CREATE_REQUEST = ::Presentation::Request::WorkSpace::CreateWorkSpaceRequest.freeze
        UPDATE_REQUEST = ::Presentation::Request::WorkSpace::UpdateWorkSpaceRequest.freeze
      end
    end
  end
end
