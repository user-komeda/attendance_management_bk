# frozen_string_literal: true

# rbs_inline: enabled

module Presentation
  module Controller
    module WorkSpace
      class WorkSpaceController < WorkSpaceControllerBase
        # @rbs () -> Array[Hash[Symbol, String]]
        def index
          work_spaces_with_status = invoke_use_case(:get_all)
          WORK_SPACE_WITH_STATUS_RESPONSE.build_from_array(status_list: work_spaces_with_status.map(&:status),
                                                           work_spaces: work_spaces_with_status.map(&:work_spaces))
        end

        # @rbs (String id) -> Hash[Symbol, String]
        def show(id)
          raise ArgumentError if ::UtilMethod.nil_or_empty?(id)

          work_space_with_member_ships = invoke_use_case(:get_detail, id)
          WORK_SPACE_WITH_MEMBER_SHIPS_RESPONSE.build(
            id: work_space_with_member_ships.work_spaces.id,
            work_spaces: work_space_with_member_ships.work_spaces,
            member_ships: work_space_with_member_ships.member_ships
          )
        end

        # @rbs (Hash[Symbol, untyped] params) -> Hash[Symbol, String]
        def create(params)
          create_work_space_request = build_request(params, CREATE_REQUEST)
          result = invoke_use_case(:create_work_space, create_work_space_request.convert_to_dto)
          WORK_SPACE_WITH_MEMBER_SHIPS_RESPONSE.build(
            id: result.work_spaces.id,
            member_ships: result.member_ships,
            work_spaces: result.work_spaces
          )
        end

        # @rbs (Hash[Symbol, untyped] params, String id) -> Hash[Symbol, String]
        def update(params, id)
          params[:id] = id
          update_work_space_request = build_request(params, UPDATE_REQUEST)
          work_space = invoke_use_case(:update_work_space, update_work_space_request.convert_to_dto)
          WORK_SPACE_RESPONSE.build(work_space: work_space)
        end

        # @rbs (String id) -> void
        def destroy(id)
          raise ArgumentError if ::UtilMethod.nil_or_empty?(id)

          invoke_use_case(:delete_work_space, id)
        end
      end
    end
  end
end
