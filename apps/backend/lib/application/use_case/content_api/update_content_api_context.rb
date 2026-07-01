# frozen_string_literal: true

# rbs_inline: enabled

module Application
  module UseCase
    module ContentApi
      class UpdateContentApiContext
        # rubocop:disable all
        attr_reader :id #: String
        attr_reader :content_api #: untyped
        attr_reader :content_api_dto #: untyped
        attr_reader :field_entities #: Array[untyped]
        # rubocop:enable all

        # @rbs (id: String, content_api: untyped, content_api_dto: untyped, field_entities: Array[untyped]) -> void
        def initialize(id:, content_api:, content_api_dto:, field_entities:)
          @id = id
          @content_api = content_api
          @content_api_dto = content_api_dto
          @field_entities = field_entities
        end
      end
    end
  end
end
