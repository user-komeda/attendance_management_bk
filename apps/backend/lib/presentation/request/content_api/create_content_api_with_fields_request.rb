# frozen_string_literal: true

# rbs_inline: enabled

module Presentation
  module Request
    module ContentApi
      class CreateContentApiWithFieldsRequest < ContentApiWithFieldsBaseRequest
        # @rbs (content_api: CreateContentApiRequest, fields: Array[CreateFieldRequest]) -> void
        def initialize(content_api:, fields:)
          super()
          @content_api = content_api
          @fields = fields
        end

        # @rbs () -> ::Application::Dto::ContentApi::CreateContentApiWithFieldsInputDto
        def convert_to_dto
          CREATE_INPUT_DTO.new(
            params: {
              content_api: @content_api.convert_to_dto,
              fields: @fields.map(&:convert_to_dto)
            }
          )
        end

        # @rbs (params: Hash[Symbol, untyped]) -> CreateContentApiWithFieldsRequest
        def self.build(params:)
          content_api = CreateContentApiRequest.build(
            params: {
              work_space_id: params[:work_space_id],
              name: params[:name],
              endpoint: params[:endpoint],
              api_type: params[:api_type]
            }
          )

          fields = params.fetch(:fields, []).map do |field_params|
            CreateFieldRequest.build(params: field_params)
          end

          CreateContentApiWithFieldsRequest.new(
            content_api: content_api,
            fields: fields
          )
        end
      end
    end
  end
end
