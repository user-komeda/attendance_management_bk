# frozen_string_literal: true

# rbs_inline: enabled

module Infrastructure
  module Repository
    module WorkSpace
      class MemberShipsRepository < MemberShipsBaseRepository
        # @rbs (user_id: String) -> Array[Array[String]]
        def work_space_ids_via_membership_by_user_id(user_id:)
          caller = resolve(ROM_REPOSITORY_KEY)
          caller.work_space_ids_via_membership_by_user_id(user_id: user_id)
        end

        # @rbs (member_ships_entity: Domain::Entity::WorkSpace::MemberShipsEntity)
        #   -> Domain::Entity::WorkSpace::MemberShipsEntity entity
        def create(member_ships_entity:)
          caller = resolve(ROM_REPOSITORY_KEY)
          created_member_ships = caller.rom_create(
            MEMBER_SHIPS_ENTITY.build_from_domain_entity(
              member_ships_entity: member_ships_entity
            )
          )
          MEMBER_SHIPS_ENTITY.struct_to_domain(struct: created_member_ships)
        end

        # @rbs (user_id: String, work_space_id: String) -> Domain::Entity::WorkSpace::MemberShipsEntity entity
        def get_by_user_id_and_work_space_id(user_id:, work_space_id:)
          caller = resolve(ROM_REPOSITORY_KEY)
          member_ships = caller.get_by_user_id_and_work_space_id(user_id: user_id, work_space_id: work_space_id)
          member_ships&.to_domain
        end
      end
    end
  end
end
