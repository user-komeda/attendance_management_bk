# frozen_string_literal: true

# rbs_inline: enabled

module Application
  module Dto
    module WorkSpace
      class WorkSpaceWithStatusDto < BaseDto
        # rubocop:disable all
        attr_reader :status #: String
        attr_reader :work_spaces #: WorkSpaceDto
        # rubocop:enable all

        private_class_method :new

        # @rbs (status: String, work_spaces: WorkSpaceDto) -> void
        def initialize(status:, work_spaces:)
          super()
          @status = status
          @work_spaces = work_spaces
        end

        # @rbs (work_space_entity: Domain::Entity::WorkSpace::WorkSpaceEntity, status: String) -> WorkSpaceWithStatusDto
        def self.build(work_space_entity:, status:)
          new(
            status: status,
            work_spaces: WorkSpaceDto.build(work_space_entity: work_space_entity)
          )
        end
      end
    end
  end
end
