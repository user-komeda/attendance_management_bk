# frozen_string_literal: true

# rbs_inline: enabled

module Domain
  module Repository
    module WorkSpace
      class ContentApiRepository < ContentApiRepositoryBase
        # @rbs (work_space_id: String) -> Array[::Domain::Entity::WorkSpace::ContentApiEntity]
        def get_by_work_space_id(work_space_id:)
          caller = resolve(REPOSITORY_KEY)
          caller.get_by_work_space_id(work_space_id: work_space_id)
        end
      end
    end
  end
end
