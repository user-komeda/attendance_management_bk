# frozen_string_literal: true

# rbs_inline: enabled

module Infrastructure
  module Repository
    module WorkSpace
      class ContentApiRepository < ContentApiBaseRepository
        # @rbs (work_space_id: String) -> Array[::Domain::Entity::WorkSpace::ContentApiEntity]
        def get_by_work_space_id(work_space_id:)
          caller = resolve(ROM_REPOSITORY_KEY)
          caller.get_by_work_space_id(work_space_id: work_space_id)
        end
      end
    end
  end
end
