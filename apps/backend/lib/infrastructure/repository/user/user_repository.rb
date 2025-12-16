# frozen_string_literal: true

# rbs_inline: enabled

module Infrastructure
  module Repository
    module User
      class UserRepository < UserBaseRepository
        # @rbs () -> Array[::Domain::Entity::User::UserEntity]
        def get_all
          caller = resolve(ROM_REPOSITORY_KEY)
          caller.rom_get_all
        end

        # @rbs (String id) -> ::Domain::Entity::User::UserEntity?
        def get_by_id(id)
          caller = resolve(ROM_REPOSITORY_KEY)
          user = caller.rom_get_by_id(id)
          user&.to_domain
        end

        # @rbs (::Domain::Entity::User::UserEntity entity) -> ::Domain::Entity::User::UserEntity
        def create(entity)
          caller = resolve(ROM_REPOSITORY_KEY)
          created_user = caller.rom_create(USER_ENTITY.build_from_domain_entity(entity))
          USER_ENTITY.struct_to_domain(created_user)
        end

        # @rbs (::Domain::Entity::User::UserEntity entity) -> ::Domain::Entity::User::UserEntity
        def update(entity)
          caller = resolve(ROM_REPOSITORY_KEY)
          updated_user = caller.rom_update(USER_ENTITY.build_from_domain_entity(entity))
          USER_ENTITY.struct_to_domain(updated_user)
        end

        # @rbs (String email) -> ::Domain::Entity::User::UserEntity?
        def find_by_email(email)
          caller = resolve(ROM_REPOSITORY_KEY)
          infra_entity = caller.find_by_email(email)
          infra_entity&.to_domain
        end

        # rubocop:disable Layout/LineLength
        # @rbs ({user: Domain::Entity::User::UserEntity, auth_user: Domain::Entity::Auth::AuthUserEntity}) -> {user_entity: Domain::Entity::User::UserEntity, auth_user_entity: Domain::Entity::Auth::AuthUserEntity}
        # rubocop:enable Layout/LineLength
        def create_with_auth_user(attrs)
          caller = resolve(ROM_REPOSITORY_KEY)
          infra_entity = caller.create_with_auth_user(USER_ENTITY.build_with_auth_user(attrs))
          USER_ENTITY.struct_to_domain_with_auth_user(infra_entity)
        end
      end
    end
  end
end
