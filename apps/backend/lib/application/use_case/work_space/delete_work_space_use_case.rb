# frozen_string_literal: true

# rbs_inline: enabled

module Application
  module UseCase
    module WorkSpace
      class DeleteWorkSpaceUseCase < WorkSpaceBaseUseCase
        # @rbs (arg: String) -> void
        def invoke(arg:)
          work_space_repository = resolve(WORK_SPACE_REPOSITORY)
          work_space = work_space_repository.find_by_slug(slug: arg)
          raise ::Application::Exception::NotFoundException.new(message: 'workspace not found') if work_space.nil?

          work_space_repository.delete_by_id(id: work_space.id.value)
        end
      end
    end
  end
end
