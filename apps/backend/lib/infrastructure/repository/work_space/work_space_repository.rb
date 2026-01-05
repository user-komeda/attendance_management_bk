# frozen_string_literal: true

# rbs_inline: enabled

module Infrastructure
  module Repository
    module WorkSpace
      class WorkSpaceRepository < WorkSpaceBaseRepository
        # @rbs (workspace_ids: Array[String]) -> Array[Domain::Entity::WorkSpace::WorkSpaceEntity]
        def find_by_ids(workspace_ids:)
          caller = resolve(ROM_REPOSITORY_KEY)
          work_spaces = caller.find_by_ids(workspace_ids: workspace_ids)
          work_spaces.map(&:to_domain)
        end

        # @rbs (slug: String) -> Domain::Entity::WorkSpace::WorkSpaceEntity
        def find_by_slug(slug:)
          caller = resolve(ROM_REPOSITORY_KEY)
          workspace = caller.find_by_slug(slug: slug)
          workspace&.to_domain
        end

        # @rbs (id: String) -> Domain::Entity::WorkSpace::WorkSpaceEntity
        def get_by_id(id:)
          caller = resolve(ROM_REPOSITORY_KEY)
          workspace = caller.rom_get_by_id(id: id)
          workspace&.to_domain
        end

        # @rbs (workspace_entity: Domain::Entity::WorkSpace::WorkSpaceEntity) -> Domain::Entity::WorkSpace::WorkSpaceEntity
        def create(workspace_entity:)
          caller = resolve(ROM_REPOSITORY_KEY)
          created_workspace = caller.rom_create(
            workspace_entity: WORKSPACE_ENTITY.build_from_domain_entity(
              workspace_entity: workspace_entity
            )
          )
          WORKSPACE_ENTITY.struct_to_domain(struct: created_workspace)
        end

        # @rbs (workspace_entity: Domain::Entity::WorkSpace::WorkSpaceEntity) -> Domain::Entity::WorkSpace::WorkSpaceEntity
        def update(workspace_entity:)
          caller = resolve(ROM_REPOSITORY_KEY)
          updated_workspace = caller.rom_update(
            workspace_entity: WORKSPACE_ENTITY.build_from_domain_entity(
              workspace_entity: workspace_entity
            )
          )
          WORKSPACE_ENTITY.struct_to_domain(struct: updated_workspace)
        end

        # @rbs (id: String) -> String
        def delete_by_id(id:)
          caller = resolve(ROM_REPOSITORY_KEY)
          caller.rom_delete(id: id).id
        end
      end
    end
  end
end
