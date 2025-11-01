
# frozen_string_literal: true

# rbs_inline: enabled

module Infrastructure
  module Repository
    module User
      class UserBaseRepository
        include Infrastructure::Repository::RepositoryBase
        KEY = Constant::ContainerKey::RomRepositoryKey::ROM_REPOSITORY[:user].key.freeze
        USER_ENTITY = ::Infrastructure::Entity::User::UserEntity
      end
    end
  end
end