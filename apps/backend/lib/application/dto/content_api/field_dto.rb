# frozen_string_literal: true

# rbs_inline: enabled

module Application
  module Dto
    module ContentApi
      class FieldDto < BaseDto
        # rubocop:disable all
        attr_reader :id, :content_api_id, :field_id, :display_name, :field_type #: String
        attr_reader :required, :unique_value, :is_active #: bool
        attr_reader :order_index #: Integer
        attr_reader :settings #: Hash[Symbol, untyped]
        # rubocop:enable all

        private_class_method :new

        # @rbs (params: Hash[Symbol, untyped]) -> void
        def initialize(params:)
          super()
          @id = params[:id]
          @content_api_id = params[:content_api_id]
          @field_id = params[:field_id]
          @display_name = params[:display_name]
          @field_type = params[:field_type]
          @required = params[:required]
          @unique_value = params[:unique_value]
          @order_index = params[:order_index]
          @is_active = params[:is_active]
          @settings = params[:settings]
        end

        # @rbs (::Domain::Entity::ContentApi::FieldEntity field_entity) -> FieldDto
        def self.build(field_entity)
          new(params: entity_to_params(field_entity: field_entity))
        end

        # @rbs (Array[::Domain::Entity::ContentApi::FieldEntity] field_entities) -> Array[FieldDto]
        def self.build_from_array(field_entities)
          field_entities.map { |field_entity| build(field_entity) }
        end

        class << self
          private

          # @rbs (field_entity: ::Domain::Entity::ContentApi::FieldEntity) -> Hash[Symbol, untyped]
          def entity_to_params(field_entity:)
            {
              id: field_entity.id&.value || '',
              content_api_id: field_entity.content_api_id.value,
              field_id: field_entity.field_id,
              display_name: field_entity.display_name,
              field_type: field_entity.field_type,
              required: field_entity.required,
              unique_value: field_entity.unique_value,
              order_index: field_entity.order_index,
              is_active: field_entity.is_active,
              settings: field_entity.settings
            }
          end
        end
      end
    end
  end
end
