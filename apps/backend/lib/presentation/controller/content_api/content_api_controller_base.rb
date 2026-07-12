# frozen_string_literal: true
# rbs_inline: enabled

module Presentation
  module Controller
    module ContentApi
      class ContentApiControllerBase < Presentation::Controller::ControllerBase
        CONTENT_API_USE_CASE = Constant::ContainerKey::ApplicationKey::CONTENT_API_USE_CASE.freeze
        USE_CASE_CONTAINER = CONTENT_API_USE_CASE

        CONTENT_API_RESPONSE = ::Presentation::Response::ContentApi::ContentApiResponse.freeze
        CONTENT_API_WITH_FIELDS_RESPONSE = ::Presentation::Response::ContentApi::ContentApiWithFieldsResponse.freeze

        BASE_REQUEST = ::Presentation::Request::ContentApi::ContentApiWithFieldsBaseRequest.freeze
        CREATE_REQUEST = ::Presentation::Request::ContentApi::CreateContentApiWithFieldsRequest.freeze
        UPDATE_REQUEST = ::Presentation::Request::ContentApi::UpdateContentApiWithFieldsRequest.freeze
      end
    end
  end
end
