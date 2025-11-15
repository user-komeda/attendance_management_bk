# frozen_string_literal: true

# rbs_inline: enabled

module Infrastructure
  module Relations
    class Users < ROM::Relation[:sql]
      schema(:users, infer: true)

      # @rbs (String email) -> ROM::Relation
      def by_email(email)
        where(email: email)
      end
    end
  end
end
