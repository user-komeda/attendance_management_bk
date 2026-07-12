# frozen_string_literal: true

# rbs_inline: enabled

module Domain
  module Repository
    module ContentApi
      class FieldRepository < FieldRepositoryBase
        # @rbs (content_api_id: String, field_entities: Array[::Domain::Entity::ContentApi::FieldEntity]) -> Array[::Domain::Entity::ContentApi::FieldEntity]
        def bulk_create(content_api_id:, field_entities:)
          caller = resolve(REPOSITORY_KEY)
          caller.bulk_create(content_api_id: content_api_id, field_entities: field_entities)
        end

        # @rbs (content_api_id: String) -> Array[::Domain::Entity::ContentApi::FieldEntity]
        def get_by_content_api_id(content_api_id:)
          caller = resolve(REPOSITORY_KEY)
          caller.get_by_content_api_id(content_api_id: content_api_id)
        end
      end
    end
  end
end
