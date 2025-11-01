# frozen_string_literal: true

# rbs_inline: enabled

module Infrastructure
  module Repository
    module RepositoryBase
      include ContainerHelper

      # @rbs () -> Array[::Domain::Entity::DomainEntity]
      def get_all
        raise NotImplementedError
      end

      # @rbs (String id) -> ::Domain::Entity::DomainEntity?
      def get_by_id(id)
        raise NotImplementedError
      end

      # @rbs (::Domain::Entity::DomainEntity entity) -> ::Domain::Entity::DomainEntity
      def create(entity)
        raise NotImplementedError
      end

      # @rbs (::Domain::Entity::DomainEntity entity) -> ::Domain::Entity::DomainEntity
      def update(entity)
        raise NotImplementedError
      end

      # @rbs (::Domain::Entity::DomainEntity entity) -> void
      def delete(entity)
        raise NotImplementedError
      end
    end
  end
end