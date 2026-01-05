# frozen_string_literal: true

# rbs_inline: enabled

module Infrastructure
  module Repository
    module Rom
      module Auth
        class AuthRomRepository < AuthBaseRomRepository
          # @rbs (email: String) -> ::Infrastructure::Entity::Auth::AuthUserEntity?
          def find_by_email(email:)
            # @type var auth_user: ::Infrastructure::Entity::Auth::AuthUserEntity?
            auth_users.map_to(Infrastructure::Entity::Auth::AuthUserEntity).by_email(email).first
          end
        end
      end
    end
  end
end
