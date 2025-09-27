# frozen_string_literal: true

module Domain
  module Repository
    module User
      class UserRepositoryBase
        include Domain::Repository::BaseRepository
        KEY = Constant::ContainerKey::RepositoryKey::REPOSITORY[:user].key.freeze
      end
    end
  end
end
