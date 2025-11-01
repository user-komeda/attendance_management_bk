# frozen_string_literal: true

# rbs_inline: enabled

module Infrastructure
  module Repository
    module Rom
      module RomRepositoryBase
        # @rbs () -> Array[::Domain::Entity::DomainEntity]
        def rom_get_all
          raise NotImplementedError
        end

        # @rbs (String id) -> ::Infrastructure::Entity::BaseEntity?
        def rom_get_by_id(id)
          raise NotImplementedError
        end

        # @rbs (::Infrastructure::Entity::BaseEntity entity) -> untyped
        def rom_create(entity)
          raise NotImplementedError
        end

        # @rbs (::Infrastructure::Entity::BaseEntity entity) -> untyped
        def rom_update(entity)
          raise NotImplementedError
        end

        # @rbs (String id) -> void
        def rom_delete(id)
          raise NotImplementedError
        end
      end
    end
  end
end