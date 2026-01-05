# frozen_string_literal: true

# rbs_inline: enabled

module Domain
  module Repository
    module Auth
      class AuthRepository < AuthRepositoryBase
        # @rbs (email: String) -> ::Infrastructure::Entity::Auth::AuthUserEntity?
        def find_by_email(email:)
          caller = resolve(REPOSITORY_KEY)
          caller.find_by_email(email: email)
        end
      end
    end
  end
end
