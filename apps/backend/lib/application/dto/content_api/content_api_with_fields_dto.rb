# frozen_string_literal: true

# rbs_inline: enabled

module Application
  module Dto
    module ContentApi
      class ContentApiWithFieldsDto < BaseDto
        # rubocop:disable all
        attr_reader :content_api #: ::Application::Dto::ContentApi::ContentApiDto
        attr_reader :fields #: Array[::Application::Dto::ContentApi::FieldDto]
        # rubocop:enable all

        private_class_method :new

        # @rbs (content_api: ContentApiDto, fields: Array[FieldDto]) -> void
        def initialize(content_api:, fields:)
          super()
          @content_api = content_api
          @fields = fields
        end

        # @rbs (content_api_entity: untyped, field_entities: Array[untyped]) -> ContentApiWithFieldsDto
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
