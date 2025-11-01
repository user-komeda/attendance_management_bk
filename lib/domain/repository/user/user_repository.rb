# frozen_string_literal: true

# rbs_inline: enabled

module Domain
  module Repository
    module User
      class UserRepository < UserRepositoryBase
        # @rbs () -> Array[::Domain::Entity::User::UserEntity]
        def get_all
          caller = resolve(KEY)
          caller.get_all
        end

        # @rbs (String id) -> ::Domain::Entity::User::UserEntity?
        def get_by_id(id)
          caller = resolve(KEY)
          caller.get_by_id(id)
        end

        # @rbs (::Domain::Entity::User::UserEntity object) -> ::Domain::Entity::User::UserEntity
        def create(object)
          caller = resolve(KEY)
          caller.create(object)
        end

        # @rbs (::Domain::Entity::User::UserEntity object) -> ::Domain::Entity::User::UserEntity
        def update(object)
          caller = resolve(KEY)
          caller.update(object)
        end

        # @rbs (::Domain::Entity::User::UserEntity object) -> void
        def delete(object)
          caller = resolve(KEY)
          caller.delete(object)
        end

        # @rbs (String email) -> ::Infrastructure::Entity::User::UserEntity?
        def find_by_email(email)
          caller = resolve(KEY)
          caller.find_by_email(email)
        end
      end
    end
  end
end