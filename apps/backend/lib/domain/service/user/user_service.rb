# frozen_string_literal: true

# rbs_inline: enabled

module Domain
  module Service
    module User
      class UserService < UserBaseService
        # @rbs (String email) -> bool
        def exist?(email)
          caller = resolve(KEY)
          result = caller.find_by_email(email)
          !result.nil?
        end
      end
    end
  end
end
