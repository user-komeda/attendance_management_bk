# frozen_string_literal: true

# rbs_inline: enabled

require_relative '../../mapper/field_mapper'

module Infrastructure
  module Entity
    module ContentApi
      # ContentApi Field の永続化データを Domain Entity に変換する ROM Struct です。
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
          ::Infrastructure::Mapper::FieldMapper.field_domain_from_struct(struct: self)
        end

        # @rbs (struct: untyped) -> ::Domain::Entity::ContentApi::FieldEntity
        def self.struct_to_domain(struct:)
          ::Infrastructure::Mapper::FieldMapper.field_domain_from_struct(struct: struct)
        end

        # @rbs (field_entity: ::Domain::Entity::ContentApi::FieldEntity, content_api_id: String) -> FieldEntity
        def self.build_from_domain_entity(field_entity:, content_api_id:)
          new(
            **::Infrastructure::Mapper::FieldMapper.field_infra_attributes_from_domain(
              domain: field_entity,
              content_api_id: content_api_id
            )
          )
        end
      end
    end
  end
end
