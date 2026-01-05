# frozen_string_literal: true

# rbs_inline: enabled

module Presentation
  module Response
    module WorkSpace
      class WorkSpaceWithMemberShipsResponse < BaseResponse
        # rubocop:disable all
        attr_reader :id #: String
        attr_reader :member_ships #: Hash[Symbol, String]
        attr_reader :work_spaces #: Hash[Symbol, String]
        # rubocop:enable all
        # @rbs (id: String, work_spaces: Hash[Symbol, String], member_ships: Hash[Symbol, String]) -> void
        # rubocop:enable all
        def initialize(id:, work_spaces:, member_ships:)
          super()
          @id = id
          @work_spaces = work_spaces
          @member_ships = member_ships
        end

        # rubocop:disable all
        # @rbs (id: String, member_ships: Application::Dto::WorkSpace::MemberShipsDto, work_spaces: Application::Dto::WorkSpace::WorkSpaceDto) -> Hash[Symbol, untyped]
        # rubocop:enable all
        def self.build(id:, member_ships:, work_spaces:)
          new(
            id: id,
            work_spaces: WorkSpaceResponse.build(work_space: work_spaces),
            member_ships: MemberShipsResponse.build(member_ships: member_ships)
          ).to_h
        end

        # rubocop:disable all
        # @rbs () -> {id: String, work_spaces: Hash[Symbol, String], member_ships: Hash[Symbol, String] }
        #
        def to_h
          {
            id: id,
            work_spaces: work_spaces,
            member_ships: member_ships
          }
        end
      end
    end
  end
end
