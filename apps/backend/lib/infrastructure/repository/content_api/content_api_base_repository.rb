# frozen_string_literal: true

# rbs_inline: enabled

module Infrastructure
  module Repository
    module ContentApi
      class ContentApiBaseRepository < RepositoryBase
        ROM_REPOSITORY_KEY = Constant::ContainerKey::RomRepositoryKey::CONTENT_API_ROM_REPOSITORY[:content_api].key.freeze
        CONTENT_API_ENTITY = ::Infrastructure::Entity::ContentApi::ContentApiEntity
        FIELD_ENTITY = ::Infrastructure::Entity::ContentApi::FieldEntity
      end
    end
  end
end
