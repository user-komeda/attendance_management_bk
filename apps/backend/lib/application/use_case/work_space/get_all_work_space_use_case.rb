# frozen_string_literal: true

# rbs_inline: enabled

module Application
  module UseCase
    module WorkSpace
      class GetAllWorkSpaceUseCase < WorkSpaceBaseUseCase
        # @rbs (arg: ::Application::Dto::WorkSpace::GetAllWorkSpaceInputDto) -> { data: Array[::Application::Dto::WorkSpace::WorkSpaceWithStatusDto], total_count: Integer }
        def invoke(arg:)
          user_id = ContextHelper.get_context(:auth_context)[:user_id]
          member_ships = resolve(MEMBER_SHIPS_REPOSITORY).work_space_ids_via_membership_by_user_id(user_id: user_id)
          return { data: [], total_count: 0 } if member_ships.empty?

          fetch_work_spaces(arg, member_ships)
        end

        private

        def fetch_work_spaces(arg, member_ships)
          work_space_ids, status_list = member_ships.transpose
          status_map = work_space_ids.zip(status_list).to_h
          result = resolve(WORK_SPACE_REPOSITORY).find_by_ids_with_pagination(
            workspace_ids: work_space_ids, page: arg.page, per_page: arg.per_page, search_query: arg.search_query
          )
          { data: build_dto_list(result[:data], status_map), total_count: result[:total_count] }
        end

        def build_dto_list(work_spaces, status_map)
          work_spaces.map do |work_space|
            status = status_map[work_space.id.value] || ''
            WORK_SPACE_WITH_STATUS_DTO.build(work_space_entity: work_space, status: status)
          end
        end
      end
    end
  end
end
