# frozen_string_literal: true

# rbs_inline: enabled

module Application
  module UseCase
    module WorkSpace
      class GetAllWorkSpaceUseCase < WorkSpaceBaseUseCase
        # @rbs () -> Array[::Application::Dto::WorkSpace::WorkSpaceWithStatusDto]
        def invoke
          work_space_repository = resolve(WORK_SPACE_REPOSITORY)
          member_ships_repository = resolve(MEMBER_SHIPS_REPOSITORY)
          user_id = Context.get_context(:auth_context)[:user_id]
          member_ships = member_ships_repository.work_space_ids_via_membership_by_user_id(user_id: user_id)
          return [] if member_ships.empty?

          work_space_ids, status_list = member_ships.transpose
          result = work_space_repository.find_by_ids(workspace_ids: work_space_ids)
          result.zip(status_list).map do |work_space, status|
            WORK_SPACE_WITH_STATUS_DTO.build(work_space_entity: work_space, status: status)
          end
        end
      end
    end
  end
end
