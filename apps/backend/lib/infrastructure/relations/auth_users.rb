# frozen_string_literal: true

# rbs_inline: enabled
module Infrastructure
  module Relations
    class AuthUsers < ROM::Relation[:sql]
      schema(:auth_users, infer: true) do
        associations do
          belongs_to :user
        end
      end
      # @rbs (String email) -> ROM::Relation
      def by_email(email)
        where(email: email)
      end
    end
  end
end
