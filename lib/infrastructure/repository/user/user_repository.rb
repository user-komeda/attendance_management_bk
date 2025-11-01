# frozen_string_literal: true

# rbs_inline: enabled

module Infrastructure
  module Repository
    module User
      class UserRepository < UserBaseRepository
        # @rbs () -> Array[::Domain::Entity::User::UserEntity]
        def get_all
          caller = resolve(KEY)
          caller.rom_get_all
        end

        # @rbs (String id) -> ::Domain::Entity::User::UserEntity?
        def get_by_id(id)
          caller = resolve(KEY)
          user = caller.rom_get_by_id(id)
          user&.to_domain
        end

        # @rbs (::Domain::Entity::User::UserEntity entity) -> ::Domain::Entity::User::UserEntity
        def create(entity)
          caller = resolve(KEY)
          created_user = caller.rom_create(USER_ENTITY.build_from_domain_entity(entity))
          USER_ENTITY.struct_to_domain(created_user)
        end

        # @rbs (::Domain::Entity::User::UserEntity entity) -> ::Domain::Entity::User::UserEntity
        def update(entity)
          caller = resolve(KEY)
          updated_user = caller.rom_update(USER_ENTITY.build_from_domain_entity(entity))
          USER_ENTITY.struct_to_domain(updated_user)
        end

        # @rbs (String email) -> ::Domain::Entity::User::UserEntity?
        def find_by_email(email)
          caller = resolve(KEY)
          infra_entity = caller.find_by_email(email)
          infra_entity&.to_domain
        end
      end
    end
  end
end