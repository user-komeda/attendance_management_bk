# frozen_string_literal: true

# rbs_inline: enabled

module Application
  module UseCase
    module WorkSpace
      class WorkSpaceBaseUseCase < BaseUseCase
        WORK_SPACE_REPOSITORY = Constant::ContainerKey::DomainRepositoryKey::WORK_SPACE_DOMAIN_REPOSITORY[:work_space]
                                .key.freeze # : String
        MEMBER_SHIPS_REPOSITORY = Constant::ContainerKey::DomainRepositoryKey::WORK_SPACE_DOMAIN_REPOSITORY[:member_ships]
                                  .key.freeze # : String
        WORK_SPACE_SERVICE = Constant::ContainerKey::ServiceKey::WORK_SPACE_SERVICE[:work_space].key.freeze # : String
        WORK_SPACE_DTO = Dto::WorkSpace::WorkSpaceDto.freeze # : singleton(Dto::WorkSpace::WorkSpaceDto)
        MEMBER_SHIPS_DTO = Dto::WorkSpace::MemberShipsDto.freeze # : singleton(Dto::WorkSpace::MemberShipsDto)
        WORK_SPACE_WITH_STATUS_DTO = Dto::WorkSpace::WorkSpaceWithStatusDto.freeze # : singleton(Dto::WorkSpace::WorkSpaceWithStatusDto)
        WORK_SPACE_WITH_MEMBER_SHIPS_DTO = Dto::WorkSpace::WorkSpaceWithMemberShipsDto.freeze # : singleton(Dto::WorkSpace::WorkSpaceWithMemberShipsDto)
      end
    end
  end
end
