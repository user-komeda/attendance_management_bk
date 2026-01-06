# frozen_string_literal: true

# rbs_inline: enabled

module Domain
  module Repository
    module WorkSpace
      class MemberShipsRepositoryBase < BaseRepository
        REPOSITORY_KEY = Constant::ContainerKey::RepositoryKey::WORK_SPACE_REPOSITORY[:member_ships].key.freeze
      end
    end
  end
end
