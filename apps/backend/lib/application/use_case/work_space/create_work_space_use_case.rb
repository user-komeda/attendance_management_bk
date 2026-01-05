# frozen_string_literal: true

# rbs_inline: enabled

module Application
  module UseCase
    module WorkSpace
      class CreateWorkSpaceUseCase < WorkSpaceBaseUseCase
        # @rbs (args: ::Application::Dto::WorkSpace::CreateWorkSpaceInputDto) -> ::Application::Dto::WorkSpace::WorkSpaceWithMemberShipsDto
        def invoke(args:)
          user_id = Context.get_context(:auth_context)[:user_id]
          rom = resolve('db.config')

          rom.gateways[:default].transaction do
            validate_uniqueness!(slug: args.slug)

            created_workspace = create_workspace(input_dto: args)
            created_member_ships = create_memberships(
              input_dto: args,
              user_id: user_id,
              workspace_id: created_workspace.id.value
            )

            WORK_SPACE_WITH_MEMBER_SHIPS_DTO.build(work_space_entity: created_workspace,
                                                   member_ships: created_member_ships)
          end
        end

        private

        # @rbs (slug: String) -> void
        def validate_uniqueness!(slug:)
          work_space_service = resolve(WORK_SPACE_SERVICE)
          return unless work_space_service.exists_by_slug?(slug: slug)

          raise ::Application::Exception::DuplicatedException.new(message: 'workspace already exists')
        end

        # @rbs (input_dto: ::Application::Dto::WorkSpace::CreateWorkSpaceInputDto) -> ::Domain::Entity::WorkSpace::WorkSpaceEntity
        def create_workspace(input_dto:)
          work_space_repository = resolve(WORK_SPACE_REPOSITORY)
          work_space_repository.create(workspace_entity: input_dto.convert_to_entity)
        end

        # rubocop:disable Layout/LineLength
        # @rbs (input_dto: ::Application::Dto::WorkSpace::CreateWorkSpaceInputDto, user_id: String, workspace_id: String) -> ::Domain::Entity::WorkSpace::MemberShipsEntity
        # rubocop:enable Layout/LineLength
        def create_memberships(input_dto:, user_id:, workspace_id:)
          member_ships_repository = resolve(MEMBER_SHIPS_REPOSITORY)
          member_ships_repository.create(member_ships_entity: input_dto.create_member_ships_entity(
            user_id: user_id, workspace_id: workspace_id
          ))
        end
      end
    end
  end
end
