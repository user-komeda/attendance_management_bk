# frozen_string_literal: true

# rbs_inline: enabled

module Presentation
  module Request
    module ContentApi
      class UpdateContentApiWithFieldsRequest < ContentApiWithFieldsBaseRequest
        # @rbs (
        #   id: String,
        #   work_space_id: String,
        #   content_api: UpdateContentApiRequest,
        #   fields: Array[CreateFieldRequest]
        # ) -> void
        def initialize(id:, work_space_id:, content_api:, fields:)
          super()
          @id = id
          @work_space_id = work_space_id
          @content_api = content_api
          @fields = fields
        end

        # @rbs () -> ::Application::Dto::ContentApi::UpdateContentApiWithFieldsInputDto
        def convert_to_dto
          ::Application::Dto::ContentApi::UpdateContentApiWithFieldsInputDto.new(
            params: {
              id: @id,
              work_space_id: @work_space_id,
              content_api: @content_api.convert_to_dto,
              fields: @fields.map(&:convert_to_dto)
            }
          )
        end

        # @rbs (params: Hash[Symbol, untyped]) -> UpdateContentApiWithFieldsRequest
        def self.build(params:)
          content_api = UpdateContentApiRequest.build(
            params: {
              name: params[:name],
              endpoint: params[:endpoint],
              api_type: params[:api_type]
            }
          )
          fields = params.fetch(:fields, []).map { |fp| CreateFieldRequest.build(params: fp) }
          new(id: params[:id], work_space_id: params[:work_space_id], content_api: content_api, fields: fields)
        end
      end
    end
  end
end
