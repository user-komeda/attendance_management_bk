# frozen_string_literal: true

# rbs_inline: enabled

module Domain
  module Repository
    class BaseRepository
      include ContainerHelper

      # @rbs () -> Array[::Domain::Entity::DomainEntity]
      def get_all
        raise NotImplementedError
      end

      # @rbs (String id) -> ::Domain::Entity::DomainEntity?
      def get_by_id(id)
        raise NotImplementedError
      end

      # @rbs (::Domain::Entity::DomainEntity object) -> ::Domain::Entity::DomainEntity
      def create(object)
        raise NotImplementedError
      end

      # @rbs (::Domain::Entity::DomainEntity object) -> ::Domain::Entity::DomainEntity
      def update(object)
        raise NotImplementedError
      end

      # @rbs (::Domain::Entity::DomainEntity object) -> void
      def delete(object)
        raise NotImplementedError
      end
    end
  end
end
