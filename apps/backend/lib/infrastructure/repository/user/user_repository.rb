# frozen_string_literal: true

# rbs_inline: enabled

module Infrastructure
  module Repository
    module User
      class UserRepository < UserBaseRepository
        # @rbs () -> Array[::Domain::Entity::User::UserEntity]
        def get_all
          rom_repository.rom_get_all.map(&:to_domain)
        end

        # @rbs (id: String) -> ::Domain::Entity::User::UserEntity?
        def get_by_id(id:)
          rom_repository.rom_get_by_id(id: id)&.to_domain
        end

        # @rbs (user_entity: Domain::Entity::User::UserEntity) -> ::Domain::Entity::User::UserEntity
        def create(user_entity:)
          created_user = rom_repository.rom_create(USER_ENTITY.build_from_domain_entity(user_entity: user_entity))
          USER_ENTITY.struct_to_domain(struct: created_user)
        end

        # @rbs (user_entity: Domain::Entity::User::UserEntity) -> ::Domain::Entity::User::UserEntity
        def update(user_entity:)
          updated_user = rom_repository.rom_update(
            user_entity: USER_ENTITY.build_from_domain_entity(
              user_entity: user_entity
            )
          )
          USER_ENTITY.struct_to_domain(struct: updated_user)
        end

        # @rbs (email: String) -> ::Domain::Entity::User::UserEntity?
        def find_by_email(email:)
          rom_repository.find_by_email(email: email)&.to_domain
        end

        # rubocop:disable Layout/LineLength
        # @rbs (user_with_auth_user: {user_with_auth_user: Domain::Entity::User::UserEntity, auth_user: Domain::Entity::Auth::AuthUserEntity}) -> {user_entity: Domain::Entity::User::UserEntity, auth_user_entity: Domain::Entity::Auth::AuthUserEntity}
        # rubocop:enable Layout/LineLength
        def create_with_auth_user(user_with_auth_user:)
          infra_entity = rom_repository.create_with_auth_user(
            USER_ENTITY.build_with_auth_user(
              user_with_auth_user: user_with_auth_user
            )
          )
          USER_ENTITY.struct_to_domain_with_auth_user(struct: infra_entity)
        end

        private

        # @rbs () -> untyped
        def rom_repository
          resolve(ROM_REPOSITORY_KEY)
        end
      end
    end
  end
end
