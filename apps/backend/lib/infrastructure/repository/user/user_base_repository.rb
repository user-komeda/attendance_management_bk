# rbs_inline: enabled

# frozen_string_literal: true

module Infrastructure
  module Repository
    module User
      class UserBaseRepository < RepositoryBase
        # @rbs ROM_REPOSITORY_KEY: String
        ROM_REPOSITORY_KEY = Constant::ContainerKey::RomRepositoryKey::USER_ROM_REPOSITORY[:user].key.freeze
        # @rbs USER_ENTITY: ::Infrastructure::Entity::User::UserEntity
        USER_ENTITY = ::Infrastructure::Entity::User::UserEntity
      end
    end
  end
end
