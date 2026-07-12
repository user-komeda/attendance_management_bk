# frozen_string_literal: true

# rbs_inline: enabled

module Infrastructure
  module Mapper
    # ContentApi Field の Infrastructure オブジェクトと Domain Entity の変換を担当します。
    class FieldMapper
      class << self
        # @rbs (struct: untyped) -> ::Domain::Entity::ContentApi::FieldEntity
        def field_domain_from_struct(struct:)
          ::Domain::Entity::ContentApi::FieldEntity.build_with_id(
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
          )
        end

        # @rbs (domain: ::Domain::Entity::ContentApi::FieldEntity, content_api_id: String) -> Hash[Symbol, untyped]
        def field_infra_attributes_from_domain(domain:, content_api_id:)
          {
            id: resolved_field_id(domain: domain),
            content_api_id: content_api_id,
            field_id: domain.field_id,
            display_name: domain.display_name,
            field_type: domain.field_type,
            required: domain.required,
            unique_value: domain.unique_value,
            order_index: domain.order_index,
            is_active: domain.is_active,
            settings: domain.settings
          }
        end

        private

        # @rbs (domain: ::Domain::Entity::ContentApi::FieldEntity) -> String
        def resolved_field_id(domain:)
          domain.id&.value || SecureRandom.uuid
        end
      end
    end
  end
end
