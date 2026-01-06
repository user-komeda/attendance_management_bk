# frozen_string_literal: true

# rbs_inline: enabled

require 'rom-repository'
module Infrastructure
  module Repository
    module Rom
      module User
        class UserRomRepository < UserBaseRomRepository
          def rom_get_all
            users.map_to(::Infrastructure::Entity::User::UserEntity).to_a
          end

          # @rbs (id: String) -> ::Infrastructure::Entity::User::UserEntity?
          def rom_get_by_id(id:)
            # @type var user: ::Infrastructure::Entity::User::UserEntity?
            users.map_to(::Infrastructure::Entity::User::UserEntity).by_pk(id).one
          end

          # @rbs (::Infrastructure::Entity::User::UserEntity entity) -> untyped
          def rom_create(entity)
            create(entity)
          end

          # @rbs (user_entity: Infrastructure::Entity::User::UserEntity) -> untyped
          def rom_update(user_entity:)
            update(user_entity.id, user_entity.to_h.slice(:first_name, :last_name, :email))
          end

          def create_with_auth_user(attrs)
            users
              .combine(:auth_users)
              .command(:create)
              .call(attrs)
          end

          # @rbs (String email) -> ::Infrastructure::Entity::User::UserEntity?
          def find_by_email(email)
            # @type var user: ::Infrastructure::Entity::User::UserEntity?
            users
              .map_to(::Infrastructure::Entity::User::UserEntity)
              .by_email(email)
              .first
          end
        end
      end
    end
  end
end
