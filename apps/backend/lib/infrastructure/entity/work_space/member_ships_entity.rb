# frozen_string_literal: true

# rbs_inline: enabled

module Infrastructure
  module Entity
    module WorkSpace
      class MemberShipsEntity < BaseEntity
        # @rbs!
        #   attr_reader id: String
        #   attr_reader user_id: String
        #   attr_reader work_space_id: String
        #   attr_reader role: String
        #   attr_reader status: String
        attribute :id, ROM::Types::String
        attribute :user_id, ROM::Types::String
        attribute :work_space_id, ROM::Types::String
        attribute :role, ROM::Types::String
        attribute :status, ROM::Types::String

        # @rbs () -> ::Domain::Entity::WorkSpace::MemberShipsEntity
        def to_domain
          ::Domain::Entity::WorkSpace::MemberShipsEntity.build_with_id(
            id: id, user_id: user_id,
            work_space_id: work_space_id,
            role: role,
            status: status
          )
        end

        # @rbs (struct: untyped) -> ::Domain::Entity::WorkSpace::MemberShipsEntity
        def self.struct_to_domain(struct:)
          member_ships_entity = new(
            id: struct.id,
            work_space_id: struct.work_space_id,
            user_id: struct.user_id,
            role: struct.role,
            status: struct.status
          )
          member_ships_entity.to_domain
        end

        # @rbs (member_ships_entity: ::Domain::Entity::WorkSpace::MemberShipsEntity) -> MemberShipsEntity
        def self.build_from_domain_entity(member_ships_entity:)
          new(
            id: extract_id(member_ships_entity: member_ships_entity),
            user_id: member_ships_entity.user_id.value,
            work_space_id: member_ships_entity.work_space_id.value,
            role: extract_role(member_ships_entity: member_ships_entity),
            status: extract_status(member_ships_entity: member_ships_entity)
          )
        end

        class << self
          private

          # @rbs (member_ships_entity: ::Domain::Entity::WorkSpace::MemberShipsEntity) -> String
          def extract_id(member_ships_entity:)
            ::UtilMethod.nil_or_empty?(member_ships_entity.id) ? SecureRandom.uuid : member_ships_entity.id.value
          end

          # @rbs (member_ships_entity: ::Domain::Entity::WorkSpace::MemberShipsEntity) -> String
          def extract_role(member_ships_entity:)
            role = member_ships_entity.role
            role.nil? ? 'owner' : role.value
          end

          # @rbs (member_ships_entity: ::Domain::Entity::WorkSpace::MemberShipsEntity) -> String
          def extract_status(member_ships_entity:)
            status = member_ships_entity.status
            status.nil? ? 'active' : status.value
          end
        end
      end
    end
  end
end
