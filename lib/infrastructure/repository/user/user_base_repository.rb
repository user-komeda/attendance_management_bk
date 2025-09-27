# frozen_string_literal: true

module Infrastructure
  module Repository
    module User
      class UserBaseRepository
        include Infrastructure::Repository::RepositoryBase
        KEY = Constant::ContainerKey::RomRepositoryKey::ROM_REPOSITORY[:user].key.freeze
        USER_ENTITY = ::Infrastructure::Entity::User::UserEntity.freeze
      end
    end
  end
end
