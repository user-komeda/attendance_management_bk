# frozen_string_literal: true

# rbs_inline: enabled

module Presentation
  module Request
    module WorkSpace
      class WorkSpaceBaseRequest < BaseRequest
        # rubocop:disable all
        attr_reader :id, :name, :slug #: String
        # rubocop:enable all

        CREATE_INPUT_DTO = ::Application::Dto::WorkSpace::CreateWorkSpaceInputDto.freeze
        UPDATE_INPUT_DTO = ::Application::Dto::WorkSpace::UpdateWorkSpaceInputDto.freeze
        CREATE_CONTRACT = ::Presentation::Request::Contract::WorkSpace::CreateWorkSpaceContract
        UPDATE_CONTRACT = ::Presentation::Request::Contract::WorkSpace::UpdateWorkSpaceContract
      end
    end
  end
end
