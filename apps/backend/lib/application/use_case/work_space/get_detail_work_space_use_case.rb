# frozen_string_literal: true

# rbs_inline: enabled

module Application
  module UseCase
    module WorkSpace
      class GetDetailWorkSpaceUseCase < WorkSpaceBaseUseCase
        # @rbs (args: String) -> ::Application::Dto::WorkSpace::WorkSpaceWithMemberShipsDto
        def invoke(args:)
          work_space_repository = resolve(WORK_SPACE_REPOSITORY)
          member_ships_repository = resolve(MEMBER_SHIPS_REPOSITORY)
          work_space = work_space_repository.get_by_id(id: args)
          raise ::Application::Exception::NotFoundException.new(message: 'workspace not found') if work_space.nil?

          user_id = Context.get_context(:auth_context)[:user_id]
          member_ships = member_ships_repository.get_by_user_id_and_work_space_id(
            user_id: user_id, work_space_id: work_space.id.value
          )
          WORK_SPACE_WITH_MEMBER_SHIPS_DTO.build(work_space_entity: work_space, member_ships: member_ships)
        end
      end
    end
  end
end
