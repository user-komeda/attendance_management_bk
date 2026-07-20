# frozen_string_literal: true

# rbs_inline: enabled

module Domain
  module Repository
    module WorkSpace
      class ContentApiRepositoryBase < BaseRepository
        REPOSITORY_KEY = Constant::ContainerKey::RepositoryKey::WORK_SPACE_REPOSITORY[:content_api].key.freeze
      end
    end
  end
end
