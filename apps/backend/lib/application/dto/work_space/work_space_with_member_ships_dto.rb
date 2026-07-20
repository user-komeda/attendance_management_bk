# frozen_string_literal: true

# rbs_inline: enabled

module Application
  module Dto
    module WorkSpace
      class WorkSpaceWithMemberShipsDto < BaseDto
        # rubocop:disable all
        attr_reader :member_ships #: untyped
        attr_reader :work_spaces #: WorkSpaceDto
        attr_reader :content_api_names #: Array[String]
        attr_reader :content_apis #: Array[Hash[Symbol, String]]
        # rubocop:enable all

        private_class_method :new

        # rubocop:disable all
        # @rbs (member_ships: untyped, work_spaces: WorkSpaceDto, content_api_names: Array[String], content_apis: Array[Hash[Symbol, String]]) -> void
        # rubocop:enable all
        def initialize(member_ships:, work_spaces:, content_api_names:, content_apis:)
          super()
          @member_ships = member_ships
          @work_spaces = work_spaces
          @content_api_names = content_api_names
          @content_apis = content_apis
        end

        # rubocop:disable all
        # @rbs (work_space_entity: ::Domain::Entity::WorkSpace::WorkSpaceEntity, member_ships: untyped, content_apis: Array[::Domain::Entity::WorkSpace::ContentApiEntity]) -> WorkSpaceWithMemberShipsDto
        # rubocop:enable all
        def self.build(work_space_entity:, member_ships:, content_apis:)
          member_ships_dto = if member_ships.is_a?(Array)
                               member_ships.map { |member_ship| MemberShipsDto.build(member_ship) }
                             else
                               MemberShipsDto.build(member_ships)
                             end

          new(
            member_ships: member_ships_dto,
            work_spaces: WorkSpaceDto.build(work_space_entity: work_space_entity),
            content_api_names: content_apis.map(&:name),
            content_apis: content_apis.map { |content_api| { name: content_api.name, api_type: content_api.api_type } }
          )
        end
      end
    end
  end
end
