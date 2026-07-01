# frozen_string_literal: true

# rbs_inline: enabled

module Infrastructure
  module Repository
    module WorkSpace
      class ContentApiBaseRepository < RepositoryBase
        ROM_REPOSITORY_KEY = Constant::ContainerKey::RomRepositoryKey::WORK_SPACE_ROM_REPOSITORY[:content_api].key.freeze
        CONTENT_API_ENTITY = ::Infrastructure::Entity::WorkSpace::ContentApiEntity
      end
    end
  end
end
