# frozen_string_literal: true

# rbs_inline: enabled

module Application
  module Dto
    module ContentApi
      class ContentApiWithFieldsDto < BaseDto
        attr_reader :content_api, :fields # : ::Application::Dto::ContentApi::ContentApiDto

        # : Array[::Application::Dto::ContentApi::FieldDto]

        private_class_method :new

        # @rbs (
        #   content_api: ::Application::Dto::ContentApi::ContentApiDto,
        #   fields: Array[::Application::Dto::ContentApi::FieldDto]
        # ) -> void
        def initialize(content_api:, fields:)
          super()
          @content_api = content_api
          @fields = fields
        end

        # @rbs (
        #   content_api_entity: ::Domain::Entity::ContentApi::ContentApiEntity,
        #   field_entities: Array[::Domain::Entity::ContentApi::FieldEntity]
        # ) -> ContentApiWithFieldsDto
        def self.build(content_api_entity:, field_entities:)
          new(
            content_api: ContentApiDto.build(content_api_entity),
            fields: FieldDto.build_from_array(field_entities)
          )
        end
      end
    end
  end
end
