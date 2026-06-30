# frozen_string_literal: true

# rbs_inline: enabled

module Infrastructure
  module Repository
    module ContentApi
      class ContentApiRepository < ContentApiBaseRepository
        # @rbs (content_api_entity: ::Domain::Entity::ContentApi::ContentApiEntity) -> ::Domain::Entity::ContentApi::ContentApiEntity
        def create(content_api_entity:)
          caller = resolve(ROM_REPOSITORY_KEY)
          created = caller.rom_create(
            content_api_entity: CONTENT_API_ENTITY.build_from_domain_entity(content_api_entity: content_api_entity)
          )
          build_entity_with_fields(
            caller: caller,
            domain: CONTENT_API_ENTITY.struct_to_domain(struct: created),
            field_entities: content_api_entity.fields
          )
        end

        # @rbs (id: String) -> ::Domain::Entity::ContentApi::ContentApiEntity?
        def find_by_id(id:)
          caller = resolve(ROM_REPOSITORY_KEY)
          struct = caller.rom_get_by_id(id: id)
          return nil if struct.nil?

          CONTENT_API_ENTITY.struct_to_domain_with_fields(struct: struct)
        end

        # @rbs (content_api_entity: ::Domain::Entity::ContentApi::ContentApiEntity) -> ::Domain::Entity::ContentApi::ContentApiEntity
        def update(content_api_entity:)
          caller = resolve(ROM_REPOSITORY_KEY)
          infra_entity = CONTENT_API_ENTITY.build_from_domain_entity(content_api_entity: content_api_entity)
          updated = caller.rom_update(content_api_entity: infra_entity)
          updated_domain = CONTENT_API_ENTITY.struct_to_domain(struct: updated)
          caller.rom_delete_fields_by_content_api_id(content_api_id: updated_domain.id.value)
          build_entity_with_fields(
            caller: caller,
            domain: updated_domain,
            field_entities: content_api_entity.fields
          )
        end

        # @rbs (id: String) -> void
        def delete_by_id(id:)
          caller = resolve(ROM_REPOSITORY_KEY)
          caller.rom_delete_fields_by_content_api_id(content_api_id: id)
          caller.rom_delete(id: id)
        end

        # @rbs (work_space_id: String, endpoint: String) -> ::Domain::Entity::ContentApi::ContentApiEntity?
        def find_by_work_space_and_endpoint(work_space_id:, endpoint:)
          caller = resolve(ROM_REPOSITORY_KEY)
          result = caller.rom_find_by_work_space_and_endpoint(
            work_space_id: work_space_id,
            endpoint: endpoint
          )
          return nil if result.nil?

          CONTENT_API_ENTITY.struct_to_domain(struct: result)
        end

        private

        # @rbs (
        #   caller: untyped,
        #   domain: ::Domain::Entity::ContentApi::ContentApiEntity,
        #   field_entities: Array[::Domain::Entity::ContentApi::FieldEntity]
        # ) -> ::Domain::Entity::ContentApi::ContentApiEntity
        def build_entity_with_fields(caller:, domain:, field_entities:)
          fields = bulk_create_fields(caller: caller, content_api_id: domain.id.value, field_entities: field_entities)
          ::Domain::Entity::ContentApi::ContentApiEntity.build_with_id(
            id: domain.id.value,
            work_space_id: domain.work_space_id.value,
            name: domain.name,
            endpoint: domain.endpoint,
            api_type: domain.api_type,
            fields: fields
          )
        end

        # @rbs (
        #   caller: untyped,
        #   content_api_id: String,
        #   field_entities: Array[::Domain::Entity::ContentApi::FieldEntity]
        # ) -> Array[::Domain::Entity::ContentApi::FieldEntity]
        def bulk_create_fields(caller:, content_api_id:, field_entities:)
          infra_entities = field_entities.map do |field_entity|
            FIELD_ENTITY.build_from_domain_entity(field_entity: field_entity, content_api_id: content_api_id)
          end
          caller.rom_bulk_create(infra_entities).map do |struct|
            FIELD_ENTITY.struct_to_domain(struct: struct)
          end
        end
      end
    end
  end
end
