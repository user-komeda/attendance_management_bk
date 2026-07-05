# frozen_string_literal: true

# rbs_inline: enabled

module Application
  module UseCase
    module WorkSpace
      class GetDetailWorkSpaceUseCase < WorkSpaceBaseUseCase
        # @rbs (arg: String) -> ::Application::Dto::WorkSpace::WorkSpaceWithMemberShipsDto
        def invoke(arg:)
          work_space = find_work_space(arg)
          build_dto(work_space)
        end

        private

        # @rbs (String) -> untyped
        def find_work_space(slug)
          work_space = resolve(WORK_SPACE_REPOSITORY).find_by_slug(slug: slug)
          raise ::Application::Exception::NotFoundException.new(message: 'workspace not found') if work_space.nil?

          work_space
        end

        # @rbs (untyped) -> ::Application::Dto::WorkSpace::WorkSpaceWithMemberShipsDto
        def build_dto(work_space)
          work_space_id = work_space.id.value
          member_ships = resolve(MEMBER_SHIPS_REPOSITORY).get_by_work_space_id(work_space_id: work_space_id)
          content_apis = resolve(CONTENT_API_REPOSITORY).get_by_work_space_id(work_space_id: work_space_id)
          WORK_SPACE_WITH_MEMBER_SHIPS_DTO.build(
            work_space_entity: work_space,
            member_ships: member_ships,
            content_apis: content_apis
          )
        end
      end
    end
  end
end
