# frozen_string_literal: true

# rbs_inline: enabled

module Infrastructure
  module Entity
    module ContentApi
      class FieldEntity < BaseEntity
        # @rbs!
        #   attr_reader id: String
        #   attr_reader content_api_id: String
        #   attr_reader field_id: String
        #   attr_reader display_name: String
        #   attr_reader field_type: String
        #   attr_reader required: bool
        #   attr_reader unique_value: bool
        #   attr_reader order_index: Integer
        #   attr_reader is_active: bool
        #   attr_reader settings: Hash[Symbol, untyped]
        attribute :id, ROM::Types::String
        attribute :content_api_id, ROM::Types::String
        attribute :field_id, ROM::Types::String
        attribute :display_name, ROM::Types::String
        attribute :field_type, ROM::Types::String
        attribute :required, ROM::Types::Bool
        attribute :unique_value, ROM::Types::Bool
        attribute :order_index, ROM::Types::Integer
        attribute :is_active, ROM::Types::Bool
        attribute :settings, ROM::Types::Hash

        # @rbs () -> ::Domain::Entity::ContentApi::FieldEntity
        def to_domain
          ::Domain::Entity::ContentApi::FieldEntity.build_with_id(
            id: id,
            content_api_id: content_api_id,
            field_id: field_id,
            display_name: display_name,
            field_type: field_type,
            required: required,
            unique_value: unique_value,
            order_index: order_index,
            is_active: is_active,
            settings: settings
          )
        end

        # @rbs (struct: untyped) -> ::Domain::Entity::ContentApi::FieldEntity
        def self.struct_to_domain(struct:)
          new(
            id: struct.id,
            content_api_id: struct.content_api_id,
            field_id: struct.field_id,
            display_name: struct.display_name,
            field_type: struct.field_type,
            required: struct.required,
            unique_value: struct.unique_value,
            order_index: struct.order_index,
            is_active: struct.is_active,
            settings: struct.settings
          ).to_domain
        end

        # @rbs (field_entity: ::Domain::Entity::ContentApi::FieldEntity, content_api_id: String) -> FieldEntity
        def self.build_from_domain_entity(field_entity:, content_api_id:)
          # :nocov:
          resolved_id = ::UtilMethod.nil_or_empty?(field_entity.id) ? SecureRandom.uuid : field_entity.id&.value
          # :nocov:
          new(
            id: resolved_id,
            content_api_id: content_api_id,
            field_id: field_entity.field_id,
            display_name: field_entity.display_name,
            field_type: field_entity.field_type,
            required: field_entity.required,
            unique_value: field_entity.unique_value,
            order_index: field_entity.order_index,
            is_active: field_entity.is_active,
            settings: field_entity.settings
          )
        end
      end
    end
  end
end
