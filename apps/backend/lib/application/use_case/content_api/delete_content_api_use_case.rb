# frozen_string_literal: true

# rbs_inline: enabled

module Application
  module UseCase
    module ContentApi
      class DeleteContentApiUseCase < ContentApiBaseUseCase
        # @rbs (arg: String, work_space_id: String) -> void
        def invoke(arg:, work_space_id:)
          rom = resolve('db.config')

          rom.gateways[:default].transaction do
            content_api_repository = resolve(CONTENT_API_REPOSITORY)
            content_api_service = resolve(CONTENT_API_SERVICE)

            content_api_entity = find_content_api!(content_api_repository: content_api_repository, id: arg)
            work_space = find_workspace!(content_api_service: content_api_service, work_space_id: work_space_id)
            validate_content_api_workspace!(content_api_entity: content_api_entity, work_space: work_space)

            content_api_repository.delete_by_id(id: arg)
          end
        end

        private

        def find_content_api!(content_api_repository:, id:)
          content_api_entity = content_api_repository.find_by_id(id: id)
          if content_api_entity.nil?
            raise ::Application::Exception::NotFoundException.new(message: 'content_api not found')
          end

          content_api_entity
        end

        def find_workspace!(content_api_service:, work_space_id:)
          work_space = content_api_service.find_work_space_by_slug(slug: work_space_id)
          raise ::Application::Exception::NotFoundException.new(message: 'workspace not found') if work_space.nil?

          work_space
        end

        def validate_content_api_workspace!(content_api_entity:, work_space:)
          return if content_api_entity.work_space_id.value == work_space.id.value

          raise ::Application::Exception::NotFoundException.new(message: 'content_api not found')
        end
      end
    end
  end
end
