# frozen_string_literal: true

# rbs_inline: enabled

require_relative '../../mapper/content_api_mapper'
require_relative '../../mapper/field_mapper'

module Infrastructure
  module Repository
    module ContentApi
      class ContentApiRepository < ContentApiBaseRepository
        # @rbs (content_api_entity: ::Domain::Entity::ContentApi::ContentApiEntity) -> ::Domain::Entity::ContentApi::ContentApiEntity
        def create(content_api_entity:)
          caller = rom_caller
          created = caller.rom_create(
            content_api_entity: CONTENT_API_ENTITY.build_from_domain_entity(content_api_entity: content_api_entity)
          )
          rebuild_with_fields(
            caller: caller,
            domain: CONTENT_API_ENTITY.struct_to_domain(struct: created),
            field_entities: content_api_entity.fields
          )
        end

        # @rbs (work_space_id: String) -> Array[::Domain::Entity::ContentApi::ContentApiEntity]
        def get_by_work_space_id(work_space_id:)
          rom_caller.get_by_work_space_id(work_space_id: work_space_id)
        end

        # @rbs (id: String) -> ::Domain::Entity::ContentApi::ContentApiEntity?
        def find_by_id(id:)
          struct = rom_caller.rom_get_by_id(id: id)
          return nil unless struct

          CONTENT_API_ENTITY.struct_to_domain_with_fields(struct: struct)
        end

        # @rbs (content_api_entity: ::Domain::Entity::ContentApi::ContentApiEntity) -> ::Domain::Entity::ContentApi::ContentApiEntity
        def update(content_api_entity:)
          caller = rom_caller
          infra_entity = CONTENT_API_ENTITY.build_from_domain_entity(content_api_entity: content_api_entity)
          updated = caller.rom_update(content_api_entity: infra_entity)
          updated_domain = CONTENT_API_ENTITY.struct_to_domain(struct: updated)
          caller.rom_delete_fields_by_content_api_id(content_api_id: updated_domain.id.value)
          rebuild_with_fields(
            caller: caller,
            domain: updated_domain,
            field_entities: content_api_entity.fields
          )
        end

        # @rbs (id: String) -> void
        def delete_by_id(id:)
          rom_caller.rom_delete_fields_by_content_api_id(content_api_id: id)
          rom_caller.rom_delete(id: id)
        end

        # @rbs (work_space_id: String, endpoint: String) -> ::Domain::Entity::ContentApi::ContentApiEntity?
        def find_by_work_space_and_endpoint(work_space_id:, endpoint:)
          result = rom_caller.rom_find_by_work_space_and_endpoint(
            work_space_id: work_space_id,
            endpoint: endpoint
          )
          return nil unless result

          CONTENT_API_ENTITY.struct_to_domain(struct: result)
        end

        # @rbs (content_api_id: String) -> Array[::Domain::Entity::ContentApi::FieldEntity]
        def get_fields_by_content_api_id(content_api_id:)
          rom_caller.get_by_content_api_id(content_api_id).map do |struct|
            ::Infrastructure::Mapper::FieldMapper.field_domain_from_struct(struct: struct)
          end
        end

        private

        # rubocop:disable all
        # @rbs (caller: untyped, domain: ::Domain::Entity::ContentApi::ContentApiEntity, field_entities: Array[::Domain::Entity::ContentApi::FieldEntity]) -> ::Domain::Entity::ContentApi::ContentApiEntity
        # rubocop:enable all
        def rebuild_with_fields(caller:, domain:, field_entities:)
          fields = bulk_create_fields(caller: caller, content_api_id: domain.id.value, field_entities: field_entities)

          ::Infrastructure::Mapper::ContentApiMapper.content_api_domain_with_fields(
            domain: domain,
            fields: fields
          )
        end

        # rubocop:disable all
        # @rbs (content_api_id: String, field_entities: Array[::Domain::Entity::ContentApi::FieldEntity], caller: untyped?) -> Array[::Domain::Entity::ContentApi::FieldEntity]
        # rubocop:enable all
        def bulk_create_fields(content_api_id:, field_entities:, caller: nil)
          caller ||= rom_caller

          infra_entities = field_entities.map do |field_entity|
            ::Infrastructure::Entity::ContentApi::FieldEntity.new(
              **::Infrastructure::Mapper::FieldMapper.field_infra_attributes_from_domain(
                domain: field_entity,
                content_api_id: content_api_id
              )
            )
          end

          caller.rom_bulk_create(infra_entities).map do |struct|
            ::Infrastructure::Mapper::FieldMapper.field_domain_from_struct(struct: struct)
          end
        end

        def rom_caller
          resolve(ROM_REPOSITORY_KEY)
        end

        public :bulk_create_fields
      end
    end
  end
end
