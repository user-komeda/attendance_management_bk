# frozen_string_literal: true

# rbs_inline: enabled

module Application
  module Dto
    module ContentApi
      class CreateContentApiWithFieldsInputDto < InputBaseDto
        attr_reader :content_api, :fields # : ::Application::Dto::ContentApi::CreateContentApiInputDto

        # : Array[::Application::Dto::ContentApi::CreateFieldInputDto]

        # @rbs (
        #   params: {
        #     content_api: ::Application::Dto::ContentApi::CreateContentApiInputDto,
        #     fields: Array[::Application::Dto::ContentApi::CreateFieldInputDto]
        #   }
        # ) -> void
        def initialize(params:)
          super()
          @content_api = params[:content_api]
          @fields = params.fetch(:fields, [])
        end

        # @rbs () -> String
        def work_space_slug
          content_api.work_space_id
        end

        # @rbs (?work_space_id: String?) -> ::Domain::Entity::ContentApi::ContentApiEntity
        def convert_to_entity(work_space_id: nil)
          field_entities = fields.map { |field| field.convert_to_entity(content_api_id: '') }
          content_api.convert_to_entity_with_fields(fields: field_entities, override_work_space_id: work_space_id)
        end
      end
    end
  end
end
