# frozen_string_literal: true

# rbs_inline: enabled

module Presentation
  module Response
    module WorkSpace
      class MemberShipsResponse < BaseResponse
        # rubocop:disable all
        attr_reader :id, :user_id, :work_space_id, :role, :status #: String
        # rubocop:enable all

        # @rbs (id: String, user_id: String, work_space_id: String, role: String, status: String) -> void
        def initialize(id:, user_id:, work_space_id:, role:, status:)
          super()
          @id = id
          @user_id = user_id
          @work_space_id = work_space_id
          @role = role
          @status = status
        end

        # @rbs (member_ships: ::Application::Dto::WorkSpace::MemberShipsDto) -> Hash[Symbol, String]
        # rubocop:enable all
        def self.build(member_ships:)
          new(
            id: member_ships.id,
            user_id: member_ships.user_id,
            work_space_id: member_ships.work_space_id,
            role: member_ships.role,
            status: member_ships.status
          ).to_h
        end

        # @rbs () -> {id: String, user_id: String, work_space_id: String, role: String, status: String }
        def to_h
          {
            id: id,
            user_id: user_id,
            work_space_id: work_space_id,
            role: role,
            status: status
          }
        end
      end
    end
  end
end
