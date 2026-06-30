# frozen_string_literal: true

# rbs_inline: enabled

module Infrastructure
  module Repository
    module Rom
      module WorkSpace
        class ContentApiRomRepository < ContentApiBaseRomRepository
          # @rbs (work_space_id: String) -> Array[::Domain::Entity::WorkSpace::ContentApiEntity]
          def get_by_work_space_id(work_space_id:)
            # @type var res: Array[::Domain::Entity::WorkSpace::ContentApiEntity]
            content_apis.map_to(Entity::WorkSpace::ContentApiEntity).by_work_space_id(work_space_id).to_a.map(&:to_domain)
          end
        end
      end
    end
  end
end
