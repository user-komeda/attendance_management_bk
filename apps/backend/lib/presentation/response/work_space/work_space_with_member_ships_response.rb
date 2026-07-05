# frozen_string_literal: true

# rbs_inline: enabled

module Presentation
  module Response
    module WorkSpace
      class WorkSpaceWithMemberShipsResponse < BaseResponse
        attr_reader :id, :member_ships, :work_spaces, :content_api_names, :content_apis

        # : String
        # : Hash[Symbol, String]
        # : Hash[Symbol, String]
        # : Array[String]

        # rubocop:disable all
        # @rbs (id: String, work_spaces: Hash[Symbol, String], member_ships: untyped, content_api_names: Array[String], content_apis: Array[Hash[Symbol, String]]) -> void
        # rubocop:enable all
        def initialize(id:, work_spaces:, member_ships:, content_api_names:, content_apis:)
          super()
          @id = id
          @work_spaces = work_spaces
          @member_ships = member_ships
          @content_api_names = content_api_names
          @content_apis = content_apis
        end

        # rubocop:disable all
        # @rbs (id: String, member_ships: untyped, work_spaces: Application::Dto::WorkSpace::WorkSpaceDto, content_api_names: Array[String], content_apis: Array[Hash[Symbol, String]]) -> Hash[Symbol, untyped]
        # rubocop:enable all
        def self.build(id:, member_ships:, work_spaces:, content_api_names:, content_apis:)
          member_ships_response = if member_ships.is_a?(Array)
                                    member_ships.map do |member_ship|
                                      MemberShipsResponse.build(member_ships: member_ship)
                                    end
                                  else
                                    MemberShipsResponse.build(member_ships: member_ships)
                                  end

          new(
            id: id,
            work_spaces: WorkSpaceResponse.build(work_space: work_spaces),
            member_ships: member_ships_response,
            content_api_names: content_api_names,
            content_apis: content_apis
          ).to_h
        end

        # @rbs () -> Hash[Symbol, untyped]
        def to_h
          {
            id: id,
            work_spaces: work_spaces,
            member_ships: member_ships,
            content_api_names: content_api_names,
            content_apis: content_apis
          }
        end
      end
    end
  end
end
