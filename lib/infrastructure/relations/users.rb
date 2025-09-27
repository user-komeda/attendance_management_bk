# frozen_string_literal: true

module Infrastructure
  module Relations
    class Users < ROM::Relation[:sql]
      schema(:users, infer: true)
      def by_email(email)
        where(email: email)
      end
    end
  end
end
