# frozen_string_literal: true

module Infrastructure
  module Repository
    module Rom
      module RomRepositoryBase
        def rom_get_all
          raise NotImplementedError
        end

        def rom_get_by_id(id)
          raise NotImplementedError
        end

        def rom_create(entity)
          raise NotImplementedError
        end

        def rom_update
          raise NotImplementedError
        end

        def rom_delete
          raise NotImplementedError
        end
      end
    end
  end
end
