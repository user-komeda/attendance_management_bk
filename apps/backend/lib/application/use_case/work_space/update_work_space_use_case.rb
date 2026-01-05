# frozen_string_literal: true

# rbs_inline: enabled

module Application
  module UseCase
    module WorkSpace
      class UpdateWorkSpaceUseCase < WorkSpaceBaseUseCase
        # @rbs (args: ::Application::Dto::WorkSpace::UpdateWorkSpaceInputDto) -> ::Application::Dto::WorkSpace::WorkSpaceDto
        def invoke(args:)
          rom = resolve('db.config')

          rom.gateways[:default].transaction do
            work_space = fetch_workspace(id: args.id)
            validate_uniqueness!(new_slug: args.slug, current_slug: work_space.slug)

            updated_workspace = update_workspace(work_space: work_space, input_dto: args)
            build_dto(workspace: updated_workspace)
          end
        end

        private

        def update_workspace(work_space:, input_dto:)
          work_space_repository = resolve(WORK_SPACE_REPOSITORY)
          work_space.change(change_name: input_dto.name, change_slug: input_dto.slug)
          work_space_repository.update(workspace_entity: work_space)
        end

        def build_dto(workspace:)
          WORK_SPACE_DTO.build(work_space_entity: workspace)
        end

        def fetch_workspace(id:)
          work_space_repository = resolve(WORK_SPACE_REPOSITORY)
          work_space = work_space_repository.get_by_id(id: id)
          raise ::Application::Exception::NotFoundException.new(message: 'workspace not found') if work_space.nil?

          work_space
        end

        def validate_uniqueness!(new_slug:, current_slug:)
          return if new_slug == current_slug

          work_space_service = resolve(WORK_SPACE_SERVICE)
          return unless work_space_service.exists_by_slug?(slug: new_slug)

          raise ::Application::Exception::DuplicatedException.new(message: 'workspace already exists')
        end
      end
    end
  end
end
