# frozen_string_literal: true

# rbs_inline: enabled

module Application
  module Dto
    module WorkSpace
      class CreateWorkSpaceInputDto < InputBaseDto
        attr_reader :name, :slug # :String
        # rubocop:enable all

        # @rbs (params: Hash[Symbol, String]) -> void
        def initialize(params:)
          super()
          @id = params[:id]
          @name = params[:name]
          @slug = params[:slug]
        end

        # @rbs () -> ::Domain::Entity::WorkSpace::WorkSpaceEntity
        def convert_to_entity
          ::Domain::Entity::WorkSpace::WorkSpaceEntity.build(name: name, slug: slug)
        end

        # @rbs (user_id: String, workspace_id: String) -> Domain::Entity::WorkSpace::MemberShipsEntity
        def create_member_ships_entity(user_id:, workspace_id:)
          ::Domain::Entity::WorkSpace::MemberShipsEntity.build(user_id: user_id, work_space_id: workspace_id,
                                                               role: 'owner', status: 'active')
        end
      end
    end
  end
end
