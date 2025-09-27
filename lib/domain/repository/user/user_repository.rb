# frozen_string_literal: true

module Domain
  module Repository
    module User
      class UserRepository < UserRepositoryBase
        def get_all
          caller = resolve(KEY)
          caller.get_all
        end

        def get_by_id(id)
          caller = resolve(KEY)
          caller.get_by_id(id)
        end

        def create(object)
          caller = resolve(KEY)
          caller.create(object)
        end

        def update(object)
          caller = resolve(KEY)
          caller.update(object)
        end

        def delete(object)
          caller = resolve(KEY)
          caller.delete(object)
        end

        def find_by_email(email)
          caller = resolve(KEY)
          caller.find_by_email(email)
        end
      end
    end
  end
end
