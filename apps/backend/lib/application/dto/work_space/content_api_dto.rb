# frozen_string_literal: true

# rbs_inline: enabled

module Application
  module Dto
    module WorkSpace
      class ContentApiDto < BaseDto
        # rubocop:disable all
        attr_reader :id, :work_space_id, :name, :endpoint, :api_type #: String
        # rubocop:enable all

        private_class_method :new

        # @rbs (id: String, work_space_id: String, name: String, endpoint: String, api_type: String) -> void
        def initialize(id:, work_space_id:, name:, endpoint:, api_type:)
          super()
          @id = id
          @work_space_id = work_space_id
          @name = name
          @endpoint = endpoint
          @api_type = api_type
        end

        # @rbs (::Domain::Entity::WorkSpace::ContentApiEntity content_api_entity) -> ContentApiDto
        def self.build(content_api_entity)
          new(
            id: content_api_entity.id.value,
            work_space_id: content_api_entity.work_space_id.value,
            name: content_api_entity.name,
            endpoint: content_api_entity.endpoint,
            api_type: content_api_entity.api_type
          )
        end
      end
    end
  end
end
