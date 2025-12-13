# frozen_string_literal: true

# rbs_inline: enabled

module Domain
  module Service
    module Auth
      class AuthService < AuthBaseService
        # @rbs (String email) -> bool
        def exist?(email)
          caller = resolve(REPOSITORY_KEY)
          result = caller.find_by_email(email)
          !result.nil?
        end
      end
    end
  end
end
