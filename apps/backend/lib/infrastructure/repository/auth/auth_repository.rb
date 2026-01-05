# frozen_string_literal: true

# rbs_inline: enabled

module Infrastructure
  module Repository
    module Auth
      class AuthRepository < AuthBaseRepository
        # @rbs (email: String) -> ::Domain::Entity::Auth::AuthUserEntity?
        def find_by_email(email:)
          caller = resolve(ROM_REPOSITORY_KEY)
          infra_entity = caller.find_by_email(email: email)
          infra_entity&.to_domain
        end
      end
    end
  end
end
