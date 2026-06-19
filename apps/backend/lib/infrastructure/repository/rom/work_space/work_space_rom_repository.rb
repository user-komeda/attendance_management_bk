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

          # rubocop:disable all
          # @rbs (workspace_ids: Array[String], page: Integer, per_page: Integer, search_query: String?) -> { data: Array[Infrastructure::Entity::WorkSpace::WorkSpaceEntity], total_count: Integer }
          # rubocop:enable all
          def find_by_ids_with_pagination(workspace_ids:, page:, per_page:, search_query: nil)
            query = work_spaces.map_to(Entity::WorkSpace::WorkSpaceEntity).by_ids(workspace_ids)
            # @type var query: untyped

            if search_query && !search_query.empty?
              sequel = Object.const_get('Sequel')
              # @type var sequel: untyped
              query = query.where(sequel.ilike(:name, "%#{search_query}%"))
            end

            query = query.order(:name, :id)

            # @type var total_count: Integer
            total_count = query.count
            data = query.limit(per_page).offset((page - 1) * per_page).to_a

            { data: data, total_count: total_count }
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
