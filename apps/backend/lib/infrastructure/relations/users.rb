# frozen_string_literal: true

# rbs_inline: enabled

module Infrastructure
  module Relations
    class Users < ROM::Relation[:sql]
      schema(:users, infer: true) do
        associations do
          has_one :auth_user
        end
        # @rbs (String email) -> ROM::Relation
        def by_email(email)
          where(email: email)
        end
      end
    end
  end
end
