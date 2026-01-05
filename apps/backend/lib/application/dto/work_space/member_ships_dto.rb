# frozen_string_literal: true

# rbs_inline: enabled

module Application
  module Dto
    module WorkSpace
      class MemberShipsDto < BaseDto
        # rubocop:disable all
        attr_reader :id, :user_id, :work_space_id, :role, :status #: String
        # rubocop:enable all

        private_class_method :new

        # @rbs (id: String?, user_id: String, work_space_id: String, role: String?, status: String?) -> void
        def initialize(user_id:, work_space_id:, role:, status:, id: nil)
          super()
          @id = id
          @user_id = user_id
          @work_space_id = work_space_id
          @role = role
          @status = status
        end

        # @rbs (::Domain::Entity::WorkSpace::MemberShipsEntity member_ships_entity) -> MemberShipsDto
        def self.build(member_ships_entity)
          if UtilMethod.nil_or_empty?(member_ships_entity.role) || UtilMethod.nil_or_empty?(member_ships_entity.status)
            raise ArgumentError,
                  'role and status must not be nil'
          end

          new(
            id: member_ships_entity.id.value,
            user_id: member_ships_entity.user_id.value,
            work_space_id: member_ships_entity.work_space_id.value,
            role: member_ships_entity.role&.value,
            status: member_ships_entity.status&.value
          )
        end

        # @rbs (Array[::Domain::Entity::WorkSpace::MemberShipsEntity] member_ships_list) -> Array[MemberShipsDto]
        def self.build_from_array(member_ships_list)
          member_ships_list.map do |member_ships|
            build(member_ships)
          end
        end
      end
    end
  end
end
