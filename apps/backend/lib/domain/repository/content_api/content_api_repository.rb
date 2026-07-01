# frozen_string_literal: true

# rbs_inline: enabled

module Domain
  module Repository
    module ContentApi
      class ContentApiRepository < ContentApiRepositoryBase
        # @rbs (work_space_id: String) -> Array[::Domain::Entity::ContentApi::ContentApiEntity]
        def get_by_work_space_id(work_space_id:)
          caller = resolve(REPOSITORY_KEY)
          caller.get_by_work_space_id(work_space_id: work_space_id)
        end

        # @rbs (content_api_entity: ::Domain::Entity::ContentApi::ContentApiEntity) -> ::Domain::Entity::ContentApi::ContentApiEntity
        def create(content_api_entity:)
          caller = resolve(REPOSITORY_KEY)
          caller.create(content_api_entity: content_api_entity)
        end

        # @rbs (id: String) -> ::Domain::Entity::ContentApi::ContentApiEntity?
        def find_by_id(id:)
          caller = resolve(REPOSITORY_KEY)
          caller.find_by_id(id: id)
        end

        # @rbs (content_api_entity: ::Domain::Entity::ContentApi::ContentApiEntity) -> ::Domain::Entity::ContentApi::ContentApiEntity
        def update(content_api_entity:)
          caller = resolve(REPOSITORY_KEY)
          caller.update(content_api_entity: content_api_entity)
        end

        # @rbs (id: String) -> void
        def delete_by_id(id:)
          caller = resolve(REPOSITORY_KEY)
          caller.delete_by_id(id: id)
        end

        # @rbs (content_api_id: String, field_entities: Array[::Domain::Entity::ContentApi::FieldEntity]) -> Array[::Domain::Entity::ContentApi::FieldEntity]
        def bulk_create_fields(content_api_id:, field_entities:)
          caller = resolve(REPOSITORY_KEY)
          caller.bulk_create_fields(content_api_id: content_api_id, field_entities: field_entities)
        end

        # @rbs (content_api_id: String) -> Array[::Domain::Entity::ContentApi::FieldEntity]
        def get_fields_by_content_api_id(content_api_id:)
          caller = resolve(REPOSITORY_KEY)
          caller.get_fields_by_content_api_id(content_api_id: content_api_id)
        end

        # @rbs (work_space_id: String, endpoint: String) -> ::Domain::Entity::ContentApi::ContentApiEntity?
        def find_by_work_space_and_endpoint(work_space_id:, endpoint:)
          caller = resolve(REPOSITORY_KEY)
          caller.find_by_work_space_and_endpoint(work_space_id: work_space_id, endpoint: endpoint)
        end
      end
    end
  end
end
