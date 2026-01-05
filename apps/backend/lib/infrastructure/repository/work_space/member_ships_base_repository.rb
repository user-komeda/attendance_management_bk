# frozen_string_literal: true

# rbs_inline: enabled

module Infrastructure
  module Repository
    module WorkSpace
      class MemberShipsBaseRepository < RepositoryBase
        ROM_REPOSITORY_KEY = Constant::ContainerKey::RomRepositoryKey::WORK_SPACE_ROM_REPOSITORY[:member_ships].key.freeze
        MEMBER_SHIPS_ENTITY = ::Infrastructure::Entity::WorkSpace::MemberShipsEntity
      end
    end
  end
end
