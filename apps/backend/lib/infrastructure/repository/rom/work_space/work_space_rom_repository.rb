# frozen_string_literal: true

# rbs_inline: enabled

module Infrastructure
  module Repository
    module Rom
      module WorkSpace
        class WorkSpaceRomRepository < WorkSpaceBaseRomRepository
          # @rbs (workspace_ids: Array[String]) -> Array[Infrastructure::Entity::WorkSpace::WorkSpaceEntity]
          def find_by_ids(workspace_ids:)
            # @type var res: Array[Infrastructure::Entity::WorkSpace::WorkSpaceEntity]
            work_spaces.map_to(Entity::WorkSpace::WorkSpaceEntity).by_ids(workspace_ids).to_a
          end

          # @rbs (slug: String) -> Infrastructure::Entity::WorkSpace::WorkSpaceEntity?
          def find_by_slug(slug:)
            # @type var res: Infrastructure::Entity::WorkSpace::WorkSpaceEntity?
            work_spaces.map_to(Entity::WorkSpace::WorkSpaceEntity).by_slug(slug).one
          end

          # @rbs (id: String) -> Infrastructure::Entity::WorkSpace::WorkSpaceEntity?
          def rom_get_by_id(id:)
            # @type var res: Infrastructure::Entity::WorkSpace::WorkSpaceEntity?
            work_spaces.map_to(Entity::WorkSpace::WorkSpaceEntity).by_pk(id).one
          end

          # @rbs (workspace_entity: Infrastructure::Entity::WorkSpace::WorkSpaceEntity) -> untyped
          def rom_create(workspace_entity:)
            create(workspace_entity)
          end

          # @rbs (workspace_entity: Infrastructure::Entity::WorkSpace::WorkSpaceEntity) -> untyped
          def rom_update(workspace_entity:)
            update(workspace_entity.id, workspace_entity.to_h.slice(:name, :slug))
          end

          def rom_delete(id:)
            delete(id)
          end
        end
      end
    end
  end
end
