# frozen_string_literal: true

# rbs_inline: enabled

module Presentation
  module Request
    module ContentApi
      class ContentApiWithFieldsBaseRequest < BaseRequest
        # rubocop:disable all
        attr_reader :content_api #: CreateContentApiRequest
        attr_reader :fields #: Array[CreateFieldRequest]
        # rubocop:enable all

        CREATE_INPUT_DTO = ::Application::Dto::ContentApi::CreateContentApiWithFieldsInputDto.freeze
      end
    end
  end
end
