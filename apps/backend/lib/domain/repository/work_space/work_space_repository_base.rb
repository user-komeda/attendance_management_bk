# frozen_string_literal: true

# rbs_inline: enabled

module Domain
  module Repository
    module WorkSpace
      class WorkSpaceRepositoryBase < BaseRepository
        REPOSITORY_KEY = Constant::ContainerKey::RepositoryKey::WORK_SPACE_REPOSITORY[:work_space].key.freeze
      end
    end
  end
end
