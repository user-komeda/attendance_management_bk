# frozen_string_literal: true

# rbs_inline: enabled

module Application
  module Dto
    module WorkSpace
      class WorkSpaceDto < BaseDto
        # rubocop:disable all
        attr_reader :id, :name, :slug #: String
        # rubocop:enable all

        private_class_method :new

        # @rbs (id: String, name: String, slug: String) -> void
        def initialize(name:, slug:, id: nil)
          super()
          @id = id
          @name = name
          @slug = slug
        end

        # @rbs (work_space_entity: Domain::Entity::WorkSpace::WorkSpaceEntity) -> WorkSpaceDto
        def self.build(work_space_entity:)
          new(
            id: work_space_entity.id.value,
            name: work_space_entity.name,
            slug: work_space_entity.slug
          )
        end

        # @rbs (work_space_list: Array[::Domain::Entity::WorkSpace::WorkSpaceEntity]) -> Array[WorkSpaceDto]
        def self.build_from_array(work_space_list:)
          work_space_list.map do |work_space|
            build(work_space_entity: work_space)
          end
        end
      end
    end
  end
end
