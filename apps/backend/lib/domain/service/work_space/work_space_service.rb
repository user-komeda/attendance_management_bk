# frozen_string_literal: true

# rbs_inline: enabled

module Domain
  module Service
    module WorkSpace
      class WorkSpaceService < WorkSpaceBaseService
        # @rbs (slug: String) -> bool
        def exists_by_slug?(slug:)
          caller = resolve(REPOSITORY_KEY)
          work_space = caller.find_by_slug(slug: slug)
          !work_space.nil?
        end
      end
    end
  end
end
