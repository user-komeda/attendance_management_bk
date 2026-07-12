# frozen_string_literal: true

# rbs_inline: enabled

module Domain
  module Repository
    module ContentApi
      class ContentApiRepositoryBase < BaseRepository
        REPOSITORY_KEY = Constant::ContainerKey::RepositoryKey::CONTENT_API_REPOSITORY[:content_api].key.freeze
      end
    end
  end
end
