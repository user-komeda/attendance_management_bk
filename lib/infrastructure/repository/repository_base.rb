# frozen_string_literal: true

module Infrastructure
  module Repository
    module RepositoryBase
      include ContainerHelper

      def get_all
        raise NotImplementedError
      end

      def get_by_id(id)
        raise NotImplementedError
      end

      def create(entity)
        raise NotImplementedError
      end

      def update
        raise NotImplementedError
      end

      def delete
        raise NotImplementedError
      end
    end
  end
end
