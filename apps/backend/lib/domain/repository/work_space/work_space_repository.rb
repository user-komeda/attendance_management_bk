# frozen_string_literal: true

# rbs_inline: enabled

module Domain
  module Repository
    module WorkSpace
      class WorkSpaceRepository < WorkSpaceRepositoryBase
        # @rbs (workspace_ids: Array[String]) -> Array[::Domain::Entity::WorkSpace::WorkSpaceEntity]
        def find_by_ids(workspace_ids:)
          caller = resolve(REPOSITORY_KEY)
          caller.find_by_ids(workspace_ids: workspace_ids)
        end

        # @rbs (slug: String) -> Domain::Entity::WorkSpace::WorkSpaceEntity
        def find_by_slug(slug:)
          caller = resolve(REPOSITORY_KEY)
          caller.find_by_slug(slug: slug)
        end

        # @rbs (id: String) -> Domain::Entity::WorkSpace::WorkSpaceEntity
        def get_by_id(id:)
          caller = resolve(REPOSITORY_KEY)
          caller.get_by_id(id: id)
        end

        # @rbs (workspace_entity: Domain::Entity::WorkSpace::WorkSpaceEntity) -> Domain::Entity::WorkSpace::WorkSpaceEntity
        def create(workspace_entity:)
          caller = resolve(REPOSITORY_KEY)
          caller.create(workspace_entity: workspace_entity)
        end

        # @rbs (workspace_entity: Domain::Entity::WorkSpace::WorkSpaceEntity) -> Domain::Entity::WorkSpace::WorkSpaceEntity
        def update(workspace_entity:)
          caller = resolve(REPOSITORY_KEY)
          caller.update(workspace_entity: workspace_entity)
        end

        # @rbs (id: String) -> Domain::Entity::WorkSpace::WorkSpaceEntity
        def delete_by_id(id:)
          caller = resolve(REPOSITORY_KEY)
          caller.delete_by_id(id: id)
        end
      end
    end
  end
end
