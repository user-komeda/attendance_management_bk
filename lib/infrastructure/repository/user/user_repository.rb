# frozen_string_literal: true

module Infrastructure
  module Repository
    module User
      class UserRepository < UserBaseRepository
        def get_all
          caller = resolve(KEY)
          caller.rom_get_all
        end

        def get_by_id(id)
          caller = resolve(KEY)
          user = caller.rom_get_by_id(id)
          user&.to_domain(user)
        end

        def create(entity)
          caller = resolve(KEY)
          created_user = caller.rom_create(USER_ENTITY.build(entity))
          USER_ENTITY.struct_to_domain(created_user)
        end

        def update(entity)
          caller = resolve(KEY)
          updated_user = caller.rom_update(USER_ENTITY.build(entity))
          USER_ENTITY.struct_to_domain(updated_user)
        end

        def find_by_email(email)
          caller = resolve(KEY)
          caller.find_by_email(email)
        end
      end
    end
  end
end
