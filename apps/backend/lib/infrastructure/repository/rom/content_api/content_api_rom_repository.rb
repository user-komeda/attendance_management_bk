# frozen_string_literal: true

# rbs_inline: enabled

module Infrastructure
  module Repository
    module Rom
      module ContentApi
        class ContentApiRomRepository < ContentApiBaseRomRepository
          # @rbs (work_space_id: String) -> Array[::Domain::Entity::ContentApi::ContentApiEntity]
          def get_by_work_space_id(work_space_id:)
            # @type var res: Array[::Domain::Entity::ContentApi::ContentApiEntity]
            content_apis.map_to(Entity::ContentApi::ContentApiEntity).by_work_space_id(work_space_id).to_a.map(&:to_domain)
          end

          # @rbs (content_api_entity: Infrastructure::Entity::ContentApi::ContentApiEntity) -> untyped
          def rom_create(content_api_entity:)
            create(content_api_entity)
          end

          # @rbs (id: String) -> untyped
          def rom_get_by_id(id:)
            content_apis.combine(:fields).by_pk(id).one
          end

          # @rbs (content_api_entity: Infrastructure::Entity::ContentApi::ContentApiEntity) -> untyped
          def rom_update(content_api_entity:)
            update(content_api_entity.id, content_api_entity.to_h.slice(:name, :endpoint, :api_type))
          end

          # @rbs (id: String) -> void
          def rom_delete(id:)
            delete(id)
          end

          # @rbs (content_api_id: String) -> void
          def rom_delete_fields_by_content_api_id(content_api_id:)
            fields.by_content_api_id(content_api_id).command(:delete).call
          end

          # @rbs (Array[Infrastructure::Entity::ContentApi::FieldEntity] field_entities) -> Array[untyped]
          def rom_bulk_create(field_entities)
            field_entities.map { |entity| fields.command(:create).call(entity) }
          end

          # @rbs (work_space_id: String, endpoint: String) -> untyped
          def rom_find_by_work_space_and_endpoint(work_space_id:, endpoint:)
            content_apis.where(work_space_id: work_space_id, endpoint: endpoint).one
          end

          # @rbs (String content_api_id) -> Array[Infrastructure::Entity::ContentApi::FieldEntity]
          def get_by_content_api_id(content_api_id)
            # @type var res: Array[Infrastructure::Entity::ContentApi::FieldEntity]
            fields.map_to(Entity::ContentApi::FieldEntity).by_content_api_id(content_api_id).to_a
          end
        end
      end
    end
  end
end
