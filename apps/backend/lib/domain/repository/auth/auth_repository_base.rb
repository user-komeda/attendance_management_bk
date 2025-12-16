# frozen_string_literal: true

# rbs_inline: enabled

module Domain
  module Repository
    module Auth
      class AuthRepositoryBase < BaseRepository
        REPOSITORY_KEY = Constant::ContainerKey::RepositoryKey::AUTH_REPOSITORY[:auth].key.freeze
      end
    end
  end
end
