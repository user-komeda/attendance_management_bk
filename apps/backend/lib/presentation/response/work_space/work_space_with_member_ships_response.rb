# frozen_string_literal: true

# rbs_inline: enabled

module Presentation
  module Response
    module WorkSpace
      class WorkSpaceWithMemberShipsResponse < BaseResponse
        attr_reader :id, :member_ships, :work_spaces, :content_api_names

        # : String
        # : Hash[Symbol, String]
        # : Hash[Symbol, String]
        # : Array[String]

        # rubocop:disable all
        # @rbs (id: String, work_spaces: Hash[Symbol, String], member_ships: Hash[Symbol, String], content_api_names: Array[String]) -> void
        # rubocop:enable all
        def initialize(id:, work_spaces:, member_ships:, content_api_names:)
          super()
          @id = id
          @work_spaces = work_spaces
          @member_ships = member_ships
          @content_api_names = content_api_names
        end

        # rubocop:disable all
        # @rbs (id: String, member_ships: Application::Dto::WorkSpace::MemberShipsDto, work_spaces: Application::Dto::WorkSpace::WorkSpaceDto, content_api_names: Array[String]) -> Hash[Symbol, untyped]
        # rubocop:enable all
        def self.build(id:, member_ships:, work_spaces:, content_api_names:)
          new(
            id: id,
            work_spaces: WorkSpaceResponse.build(work_space: work_spaces),
            member_ships: MemberShipsResponse.build(member_ships: member_ships),
            content_api_names: content_api_names
          ).to_h
        end

        # @rbs () -> Hash[Symbol, untyped]
        def to_h
          {
            id: id,
            work_spaces: work_spaces,
            member_ships: member_ships,
            content_api_names: content_api_names
          }
        end
      end
    end
  end
end
