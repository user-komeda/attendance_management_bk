# frozen_string_literal: true

# rbs_inline: enabled

require 'rom-repository'
module Infrastructure
  module Repository
    module Rom
      module User
        class UserRomRepository < UserBaseRomRepository
          # @rbs () -> Array[::Domain::Entity::User::UserEntity]
          def rom_get_all
            users.map_to(::Infrastructure::Entity::User::UserEntity).to_a.map(&:to_domain)
          end

          # @rbs (String id) -> ::Infrastructure::Entity::User::UserEntity?
          def rom_get_by_id(id)
            users.map_to(::Infrastructure::Entity::User::UserEntity).by_pk(id).one
          end

          # @rbs (::Infrastructure::Entity::User::UserEntity entity) -> untyped
          def rom_create(entity)
            create(entity)
          end

          # @rbs (::Infrastructure::Entity::User::UserEntity entity) -> untyped
          def rom_update(entity)
            update(entity.id, entity.to_h.slice(:first_name, :last_name, :email))
          end

          # @rbs (String email) -> ::Infrastructure::Entity::User::UserEntity?
          def find_by_email(email)
            users.map_to(Infrastructure::Entity::User::UserEntity).by_email(email).first
          end
        end
      end
    end
  end
end