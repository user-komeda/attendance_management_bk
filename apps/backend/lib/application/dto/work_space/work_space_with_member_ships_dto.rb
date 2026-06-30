# frozen_string_literal: true

# rbs_inline: enabled

module Application
  module Dto
    module WorkSpace
      class WorkSpaceWithMemberShipsDto < BaseDto
        # rubocop:disable all
        attr_reader :member_ships #: MemberShipsDto
        attr_reader :work_spaces #: WorkSpaceDto
        attr_reader :content_api_names #: Array[String]
        # rubocop:enable all

        private_class_method :new

        # @rbs (member_ships: MemberShipsDto, work_spaces: WorkSpaceDto, content_api_names: Array[String]) -> void
        # rubocop:enable all
        def initialize(member_ships:, work_spaces:, content_api_names:)
          super()
          @member_ships = member_ships
          @work_spaces = work_spaces
          @content_api_names = content_api_names
        end

        # rubocop:disable all
        # @rbs (work_space_entity: ::Domain::Entity::WorkSpace::WorkSpaceEntity, member_ships: ::Domain::Entity::WorkSpace::MemberShipsEntity, content_apis: Array[::Domain::Entity::WorkSpace::ContentApiEntity]) -> WorkSpaceWithMemberShipsDto
        # rubocop:enable all
        def self.build(work_space_entity:, member_ships:, content_apis:)
          new(
            member_ships: MemberShipsDto.build(member_ships),
            work_spaces: WorkSpaceDto.build(work_space_entity: work_space_entity),
            content_api_names: content_apis.map(&:name)
          )
        end
      end
    end
  end
end
