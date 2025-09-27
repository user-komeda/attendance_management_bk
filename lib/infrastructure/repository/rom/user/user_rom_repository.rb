# frozen_string_literal: true

require 'rom-repository'
module Infrastructure
  module Repository
    module Rom
      module User
        class UserRomRepository < UserBaseRomRepository
          def rom_get_all
            users.map_to(::Infrastructure::Entity::User::UserEntity).to_a.map do |user|
              user.to_domain(user)
            end
          end

          def rom_get_by_id(id)
            users.map_to(::Infrastructure::Entity::User::UserEntity).by_pk(id).one
          end

          def rom_create(entity)
            create(entity)
          end

          def rom_update(entity)
            pp entity.id
            update(entity.id, entity.to_h.slice(:first_name, :last_name, :email))
          end

          def find_by_email(email)
            users.map_to(Infrastructure::Entity::User::UserEntity).by_email(email).first
          end
        end
      end
    end
  end
end
