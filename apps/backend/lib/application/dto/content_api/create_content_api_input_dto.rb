# frozen_string_literal: true

# rbs_inline: enabled

module Application
  module Dto
    module ContentApi
      class CreateContentApiInputDto < InputBaseDto
        # rubocop:disable all
        attr_reader :work_space_id, :name, :endpoint, :api_type #: String
        # rubocop:enable all

        # @rbs (params: Hash[Symbol, untyped]) -> void
        def initialize(params:)
          super()
          @work_space_id = params[:work_space_id]
          @name = params[:name]
          @endpoint = params[:endpoint]
          @api_type = params[:api_type]
        end

        # @rbs () -> ::Domain::Entity::ContentApi::ContentApiEntity
        def convert_to_entity
          ::Domain::Entity::ContentApi::ContentApiEntity.build(
            work_space_id: work_space_id,
            name: name,
            endpoint: endpoint,
            api_type: api_type,
            fields: []
          )
        end

        # @rbs (fields: Array[::Domain::Entity::ContentApi::FieldEntity], ?override_work_space_id: String?) -> ::Domain::Entity::ContentApi::ContentApiEntity
        def convert_to_entity_with_fields(fields:, override_work_space_id: nil)
          ::Domain::Entity::ContentApi::ContentApiEntity.build(
            work_space_id: override_work_space_id || work_space_id,
            name: name,
            endpoint: endpoint,
            api_type: api_type,
            fields: fields
          )
        end
      end
    end
  end
end
