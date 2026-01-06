# frozen_string_literal: true

# rbs_inline: enabled

module Infrastructure
  module Relations
    class Users < ROM::Relation[:sql]
      schema(:users, infer: true) do
        associations do
          has_one :auth_user
          has_many :member_ships
        end
        # :nocov:
        # @rbs (String email) -> ROM::Relation[untyped]
        def by_email(email)
          where(email: email)
        end
        # :nocov:
      end
    end
  end
end
