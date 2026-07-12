# frozen_string_literal: true

# rbs_inline: enabled

module Presentation
  module Response
    module ContentApi
      class ContentApiWithFieldsResponse < Presentation::Response::BaseResponse
        # rubocop:disable all
        attr_reader :content_api #: Hash[Symbol, untyped]
        attr_reader :fields #: Array[Hash[Symbol, untyped]]
        # rubocop:enable all

        # @rbs (content_api: Hash[Symbol, untyped], fields: Array[Hash[Symbol, untyped]]) -> void
        def initialize(content_api:, fields:)
          super()
          @content_api = content_api
          @fields = fields
        end

        # @rbs (content_api_with_fields: untyped) -> Hash[Symbol, untyped]
        def self.build(content_api_with_fields:)
          new(
            content_api: ContentApiResponse.build(content_api: content_api_with_fields.content_api),
            fields: content_api_with_fields.fields.map { |field| field_to_h(field) }
          ).to_h
        end

        # @rbs () -> {content_api: Hash[Symbol, untyped], fields: Array[Hash[Symbol, untyped]]}
        def to_h
          {
            content_api: content_api,
            fields: fields
          }
        end

        class << self
          private

          # @rbs (untyped field) -> Hash[Symbol, untyped]
          def field_to_h(field)
            {
              id: field.id,
              content_api_id: field.content_api_id,
              field_id: field.field_id,
              display_name: field.display_name,
              field_type: field.field_type,
              required: field.required,
              unique_value: field.unique_value,
              order_index: field.order_index,
              is_active: field.is_active,
              settings: field.settings
            }
          end
        end
      end
    end
  end
end
