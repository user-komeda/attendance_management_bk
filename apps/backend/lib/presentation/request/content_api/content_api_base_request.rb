# frozen_string_literal: true

# rbs_inline: enabled

module Presentation
  module Request
    module ContentApi
      class ContentApiBaseRequest < BaseRequest
        # rubocop:disable all
        attr_reader :work_space_id, :name, :endpoint, :api_type #: String
        # rubocop:enable all

        CREATE_INPUT_DTO = ::Application::Dto::ContentApi::CreateContentApiInputDto.freeze
        CREATE_CONTRACT = ::Presentation::Request::Contract::ContentApi::CreateContentApiContract
      end
    end
  end
end
