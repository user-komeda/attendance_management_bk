# frozen_string_literal: true

# rbs_inline: enabled

module Application
  module Dto
    module WorkSpace
      class WorkSpaceWithMemberShipsDto < BaseDto
        # rubocop:disable all
        attr_reader :member_ships #: MemberShipsDto
        attr_reader :work_spaces #: WorkSpaceDto
        # rubocop:enable all

        private_class_method :new

        # @rbs (member_ships: MemberShipsDto, work_spaces: WorkSpaceDto) -> void
        # rubocop:enable all
        def initialize(member_ships:, work_spaces:)
          super()
          @member_ships = member_ships
          @work_spaces = work_spaces
        end

        # rubocop:disable all
        # @rbs (work_space_entity: ::Domain::Entity::WorkSpace::WorkSpaceEntity, member_ships: ::Domain::Entity::WorkSpace::MemberShipsEntity) -> WorkSpaceWithMemberShipsDto
        # rubocop:enable all
        def self.build(work_space_entity:, member_ships:)
          new(
            member_ships: MemberShipsDto.build(member_ships),
            work_spaces: WorkSpaceDto.build(work_space_entity: work_space_entity)
          )
        end
      end
    end
  end
end
