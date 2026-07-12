# frozen_string_literal: true

# rbs_inline: enabled

module Domain
  module Repository
    module ContentApi
      class FieldRepositoryBase < BaseRepository
        REPOSITORY_KEY = Constant::ContainerKey::RepositoryKey::CONTENT_API_REPOSITORY[:field].key.freeze
      end
    end
  end
end
