# frozen_string_literal: true

# rbs_inline: enabled

module Infrastructure
  module Repository
    module Rom
      module Auth
        class AuthRomRepository < AuthBaseRomRepository
          # @rbs (String email) -> ::Infrastructure::Entity::Auth::AuthUserEntity?
          def find_by_email(email)
            auth_users.map_to(Infrastructure::Entity::Auth::AuthUserEntity).by_email(email).first
          end
        end
      end
    end
  end
end
