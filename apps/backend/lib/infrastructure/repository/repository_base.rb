# frozen_string_literal: true

# rbs_inline: enabled

module Infrastructure
  module Repository
    class RepositoryBase
      include ContainerHelper

      ABSTRACT_REPOSITORY_MESSAGE = 'RepositoryBase subclasses must implement this method'

      # @rbs () -> Array[::Domain::Entity::DomainEntity]
      def get_all
        raise NotImplementedError, "#{self.class} #{ABSTRACT_REPOSITORY_MESSAGE}"
      end

      # @rbs (String id) -> ::Domain::Entity::DomainEntity?
      def get_by_id(_id)
        raise NotImplementedError, "#{self.class} #{ABSTRACT_REPOSITORY_MESSAGE}"
      end

      # @rbs (::Domain::Entity::DomainEntity entity) -> ::Domain::Entity::DomainEntity
      def create(_entity)
        raise NotImplementedError, "#{self.class} #{ABSTRACT_REPOSITORY_MESSAGE}"
      end

      # @rbs (::Domain::Entity::DomainEntity entity) -> ::Domain::Entity::DomainEntity
      def update(_entity)
        raise NotImplementedError, "#{self.class} #{ABSTRACT_REPOSITORY_MESSAGE}"
      end

      # @rbs (::Domain::Entity::DomainEntity entity) -> void
      def delete(_entity)
        raise NotImplementedError, "#{self.class} #{ABSTRACT_REPOSITORY_MESSAGE}"
      end

      private

      # @rbs () -> void
      def raise_repository_not_implemented
        raise_repository_not_implemented!
      end

      # @rbs () -> void
      def raise_repository_not_implemented!
        raise NotImplementedError, "#{self.class} #{ABSTRACT_REPOSITORY_MESSAGE}"
      end
    end
  end
end
