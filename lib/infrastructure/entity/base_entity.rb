# frozen_string_literal: true

module Infrastructure
  module Entity
    class BaseEntity < ROM::Struct
      def to_domain(entity)
        raise NotImplementedError
      end

      def self.build(entity)
        raise NotImplementedError
      end
    end
  end
end
