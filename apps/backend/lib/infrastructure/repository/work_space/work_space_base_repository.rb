# frozen_string_literal: true

# rbs_inline: enabled

module Infrastructure
  module Repository
    module WorkSpace
      class WorkSpaceBaseRepository < RepositoryBase
        ROM_REPOSITORY_KEY = Constant::ContainerKey::RomRepositoryKey::WORK_SPACE_ROM_REPOSITORY[:work_space].key.freeze
        WORKSPACE_ENTITY = ::Infrastructure::Entity::WorkSpace::WorkSpaceEntity
      end
    end
  end
end
