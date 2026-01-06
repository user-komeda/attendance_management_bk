# frozen_string_literal: true

# rbs_inline: enabled

module Application
  module Dto
    module WorkSpace
      class UpdateWorkSpaceInputDto < InputBaseDto
        attr_reader :id, :name, :slug # :String
        # rubocop:enable all

        # @rbs (id: String, name: String, slug: String) -> void
        def initialize(id:, name:, slug:)
          super()
          @id = id
          @name = name
          @slug = slug
        end

        # @rbs () -> ::Domain::Entity::WorkSpace::WorkSpaceEntity
        def convert_to_entity
          ::Domain::Entity::WorkSpace::WorkSpaceEntity.build(name: name, slug: slug)
        end
      end
    end
  end
end
