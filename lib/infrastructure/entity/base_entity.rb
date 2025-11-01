# frozen_string_literal: true

# rbs_inline: enabled

module Infrastructure
  module Entity
    class BaseEntity < ROM::Struct
      # @rbs () -> ::Domain::Entity::DomainEntity
      def self.to_domain
        raise NotImplementedError
      end

      # @rbs (untyped struct) -> ::Domain::Entity::DomainEntity
      def self.struct_to_domain(struct)
        raise NotImplementedError
      end

      # @rbs (::Domain::Entity::DomainEntity entity) -> BaseEntity
      def self.build_from_domain_entity(entity)
        raise NotImplementedError
      end
    end
  end
end