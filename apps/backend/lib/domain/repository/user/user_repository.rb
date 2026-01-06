# frozen_string_literal: true

# rbs_inline: enabled

module Domain
  module Repository
    module User
      class UserRepository < UserRepositoryBase
        # @rbs () -> Array[::Domain::Entity::User::UserEntity]
        def get_all
          caller = resolve(REPOSITORY_KEY)
          caller.get_all
        end

        # @rbs (id: String) -> ::Domain::Entity::User::UserEntity?
        def get_by_id(id:)
          caller = resolve(REPOSITORY_KEY)
          caller.get_by_id(id: id)
        end

        # @rbs (::Domain::Entity::User::UserEntity object) -> ::Domain::Entity::User::UserEntity
        def create(object)
          caller = resolve(REPOSITORY_KEY)
          caller.create(object)
        end

        # @rbs (user_entity: Domain::Entity::User::UserEntity) -> ::Domain::Entity::User::UserEntity
        def update(user_entity:)
          caller = resolve(REPOSITORY_KEY)
          caller.update(user_entity: user_entity)
        end

        # @rbs (::Domain::Entity::User::UserEntity object) -> void
        def delete(object)
          caller = resolve(REPOSITORY_KEY)
          caller.delete(object)
        end

        # @rbs (String email) -> ::Infrastructure::Entity::User::UserEntity?
        def find_by_email(email)
          caller = resolve(REPOSITORY_KEY)
          caller.find_by_email(email)
        end

        # rubocop:disable Layout/LineLength
        # @rbs (user_with_auth_user: Domain::Entity::User::UserEntity) -> {user_entity: Domain::Entity::User::UserEntity, auth_user_entity: Domain::Entity::Auth::AuthUserEntity}
        # rubocop:enable Layout/LineLength
        def create_with_auth_user(user_with_auth_user:)
          caller = resolve(REPOSITORY_KEY)
          caller.create_with_auth_user(user_with_auth_user: user_with_auth_user)
        end
      end
    end
  end
end
