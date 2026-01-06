# frozen_string_literal: true

# rbs_inline: enabled

module Domain
  module Repository
    module WorkSpace
      class MemberShipsRepository < MemberShipsRepositoryBase
        # @rbs (user_id: String) -> Array[Array[String]]
        def work_space_ids_via_membership_by_user_id(user_id:)
          caller = resolve(REPOSITORY_KEY)
          caller.work_space_ids_via_membership_by_user_id(user_id: user_id)
        end

        # @rbs (member_ships_entity: Domain::Entity::WorkSpace::MemberShipsEntity) -> Domain::Entity::WorkSpace::MemberShipsEntity
        def create(member_ships_entity:)
          caller = resolve(REPOSITORY_KEY)
          caller.create(member_ships_entity: member_ships_entity)
        end

        # @rbs (user_id: String, work_space_id: String) -> Domain::Entity::WorkSpace::MemberShipsEntity
        def get_by_user_id_and_work_space_id(user_id:, work_space_id:)
          caller = resolve(REPOSITORY_KEY)
          caller.get_by_user_id_and_work_space_id(user_id: user_id, work_space_id: work_space_id)
        end
      end
    end
  end
end
