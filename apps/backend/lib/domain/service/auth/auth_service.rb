# frozen_string_literal: true

# rbs_inline: enabled

module Domain
  module Service
    module Auth
      class AuthService < AuthBaseService
        # @rbs (email: String) -> bool
        def exist?(email:)
          caller = resolve(REPOSITORY_KEY)
          result = caller.find_by_email(email: email)
          !result.nil?
        end

        # @rbs (auth_user: Domain::Entity::Auth::AuthUserEntity, password: String) -> bool
        def can_login?(auth_user:, password:)
          return false unless auth_user.active?

          auth_user.password_match?(password)
        end
      end
    end
  end
end
