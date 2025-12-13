# frozen_string_literal: true

# rbs_inline: enabled

module Domain
  module Repository
    module User
      class UserRepositoryBase < Domain::Repository::BaseRepository
        REPOSITORY_KEY = Constant::ContainerKey::RepositoryKey::USER_REPOSITORY[:user].key.freeze
      end
    end
  end
end
