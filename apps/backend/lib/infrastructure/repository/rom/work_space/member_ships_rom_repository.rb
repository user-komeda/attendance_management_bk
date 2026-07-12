# frozen_string_literal: true

# rbs_inline: enabled

module Infrastructure
  module Repository
    module Rom
      module WorkSpace
        class MemberShipsRomRepository < MemberShipsBaseRomRepository
          # @rbs (user_id: String) -> Array[Array[String]]
          def work_space_ids_via_membership_by_user_id(user_id:)
            # @type var res: Array[Array[String]]
            member_ships.by_user_id(user_id).plunk_work_space_id_and_status.to_a
          end

          # @rbs (::Infrastructure::Entity::WorkSpace::MemberShipsEntity entity) -> untyped
          def rom_create(entity)
            create(entity)
          end

          # @rbs (work_space_id: String) -> Array[Infrastructure::Entity::WorkSpace::MemberShipsEntity]
          def get_by_work_space_id(work_space_id:)
            # @type var res: Array[Infrastructure::Entity::WorkSpace::MemberShipsEntity]
            member_ships.map_to(Entity::WorkSpace::MemberShipsEntity).by_work_space_id(work_space_id).to_a
          end
        end
      end
    end
  end
end
