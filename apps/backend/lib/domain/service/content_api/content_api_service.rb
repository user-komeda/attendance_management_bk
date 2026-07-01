# frozen_string_literal: true

# rbs_inline: enabled

module Domain
  module Service
    module ContentApi
      class ContentApiService < ContentApiBaseService
        # @rbs (work_space_id: String, endpoint: String) -> bool
        def endpoint_exists?(work_space_id:, endpoint:)
          !!find_by_work_space_and_endpoint(work_space_id: work_space_id, endpoint: endpoint)
        end

        # @rbs (work_space_id: String, endpoint: String, exclude_id: String) -> bool
        def endpoint_exists_excluding?(work_space_id:, endpoint:, exclude_id:)
          existing = find_by_work_space_and_endpoint(work_space_id: work_space_id, endpoint: endpoint)
          !!(existing && existing.id.value != exclude_id)
        end

        # @rbs (field_ids: Array[String]) -> bool
        def duplicate_field_id?(field_ids:)
          field_ids.uniq.length != field_ids.length
        end

        # @rbs (slug: String) -> Domain::Entity::WorkSpace::WorkSpaceEntity?
        def find_work_space_by_slug(slug:)
          work_space_repository = resolve(WORK_SPACE_REPOSITORY_KEY)
          work_space_repository.find_by_slug(slug: slug)
        end

        private

        # @rbs (work_space_id: String, endpoint: String) -> untyped
        def find_by_work_space_and_endpoint(work_space_id:, endpoint:)
          resolve(REPOSITORY_KEY).find_by_work_space_and_endpoint(
            work_space_id: work_space_id,
            endpoint: endpoint
          )
        end
      end
    end
  end
end
