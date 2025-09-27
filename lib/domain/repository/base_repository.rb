# frozen_string_literal: true

module Domain
  module Repository
    module BaseRepository
      include ContainerHelper
      def get_all
        raise NotImplementedError
      end

      def get_by_id(id)
        raise NotImplementedError
      end

      def create(object)
        raise NotImplementedError
      end

      def update(object)
        raise NotImplementedError
      end

      def delete(object)
        raise NotImplementedError
      end
    end
  end
end
