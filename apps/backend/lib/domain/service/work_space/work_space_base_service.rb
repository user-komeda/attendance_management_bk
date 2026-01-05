# frozen_string_literal: true

# rbs_inline: enabled

module Domain
  module Service
    module WorkSpace
      class WorkSpaceBaseService < BaseService
        REPOSITORY_KEY = Constant::ContainerKey::RepositoryKey::WORK_SPACE_REPOSITORY[:work_space].key.freeze
      end
    end
  end
end
