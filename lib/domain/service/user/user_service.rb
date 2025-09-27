# frozen_string_literal: true

module Domain
  module Service
    module User
      class UserService < UserBaseService
        def exist?(email)
          caller = resolve(KEY)
          result = caller.find_by_email(email)
          !result.nil?
        end
      end
    end
  end
end
