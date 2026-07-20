# frozen_string_literal: true

# rbs_inline: enabled

module Infrastructure
  module Mapper
    # ContentApi 系の Infrastructure オブジェクトと Domain Entity の変換を担当します。
    class ContentApiMapper
      class << self
        # @rbs (struct: untyped) -> ::Domain::Entity::ContentApi::ContentApiEntity
        def content_api_domain_from_struct(struct:)
          ::Domain::Entity::ContentApi::ContentApiEntity.build_with_id(
            id: struct.id,
            work_space_id: struct.work_space_id,
            name: struct.name,
            endpoint: struct.endpoint,
            api_type: struct.api_type,
            fields: []
          )
        end

        # @rbs (struct: untyped, fields: Array[::Domain::Entity::ContentApi::FieldEntity]) -> ::Domain::Entity::ContentApi::ContentApiEntity
        def content_api_domain_from_struct_with_fields(struct:, fields:)
          ::Domain::Entity::ContentApi::ContentApiEntity.build_with_id(
            id: struct.id,
            work_space_id: struct.work_space_id,
            name: struct.name,
            endpoint: struct.endpoint,
            api_type: struct.api_type,
            fields: fields
          )
        end

        # rubocop:disable all
        # @rbs (domain: ::Domain::Entity::ContentApi::ContentApiEntity, fields: Array[::Domain::Entity::ContentApi::FieldEntity]) -> ::Domain::Entity::ContentApi::ContentApiEntity
        # rubocop:enable all
        def content_api_domain_with_fields(domain:, fields:)
          ::Domain::Entity::ContentApi::ContentApiEntity.build_with_id(
            id: domain.id.value,
            work_space_id: domain.work_space_id.value,
            name: domain.name,
            endpoint: domain.endpoint,
            api_type: domain.api_type,
            fields: fields
          )
        end

        # @rbs (domain: ::Domain::Entity::ContentApi::ContentApiEntity) -> Hash[Symbol, String]
        def content_api_infra_attributes_from_domain(domain:)
          {
            id: domain.id&.value || SecureRandom.uuid,
            work_space_id: domain.work_space_id.value,
            name: domain.name,
            endpoint: domain.endpoint,
            api_type: domain.api_type
          }
        end

        # @rbs (struct: untyped) -> ::Domain::Entity::WorkSpace::ContentApiEntity
        def work_space_content_api_domain_from_struct(struct:)
          ::Domain::Entity::WorkSpace::ContentApiEntity.build_with_id(
            id: struct.id,
            work_space_id: struct.work_space_id,
            name: struct.name,
            endpoint: struct.endpoint,
            api_type: struct.api_type
          )
        end

        # @rbs (domain: ::Domain::Entity::WorkSpace::ContentApiEntity) -> Hash[Symbol, String]
        def work_space_content_api_infra_attributes_from_domain(domain:)
          {
            id: domain.id&.value || SecureRandom.uuid,
            work_space_id: domain.work_space_id.value,
            name: domain.name,
            endpoint: domain.endpoint,
            api_type: domain.api_type
          }
        end
      end
    end
  end
end
