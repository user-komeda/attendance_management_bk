# frozen_string_literal: true

# rbs_inline: enabled

module Application
  module UseCase
    module ContentApi
      class DeleteContentApiUseCase < ContentApiBaseUseCase
        # @rbs (arg: String, work_space_id: String) -> void
        def invoke(arg:, work_space_id:)
          with_transaction do
            content_api_repository = resolve(CONTENT_API_REPOSITORY)
            content_api_service = resolve(CONTENT_API_SERVICE)

            content_api_entity = find_content_api!(content_api_repository: content_api_repository, id: arg)
            work_space = find_workspace_by_slug!(content_api_service: content_api_service,
                                                 work_space_slug: work_space_id)
            validate_content_api_workspace!(content_api: content_api_entity, work_space: work_space)

            content_api_repository.delete_by_id(id: arg)
          end
        end
      end
    end
  end
end
