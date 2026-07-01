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
          new(**struct_attributes(struct:)).to_domain
        end

        # @rbs (member_ships_entity: ::Domain::Entity::WorkSpace::MemberShipsEntity) -> MemberShipsEntity
        def self.build_from_domain_entity(member_ships_entity:)
          new(**domain_attributes(member_ships_entity: member_ships_entity))
        end

        class << self
          private

          # @rbs (member_ships_entity: ::Domain::Entity::WorkSpace::MemberShipsEntity) -> String
          def extract_id(member_ships_entity:)
            member_ship_id = member_ships_entity.id

            ::UtilMethod.nil_or_empty?(member_ship_id) ? SecureRandom.uuid : member_ship_id.value
          end

          # @rbs (struct: untyped) -> Hash[Symbol, String]
          def struct_attributes(struct:)
            {
              id: struct.id,
              work_space_id: struct.work_space_id,
              user_id: struct.user_id,
              role: struct.role,
              status: struct.status
            }
          end

          # @rbs (member_ships_entity: ::Domain::Entity::WorkSpace::MemberShipsEntity) -> Hash[Symbol, String]
          def domain_attributes(member_ships_entity:)
            role = member_ships_entity.role
            status = member_ships_entity.status

            {
              id: extract_id(member_ships_entity: member_ships_entity),
              user_id: member_ships_entity.user_id.value,
              work_space_id: member_ships_entity.work_space_id.value,
              role: extract_or_default(value_object: role, default_value: 'owner'),
              status: extract_or_default(value_object: status, default_value: 'active')
            }
          end

          # @rbs (value_object: untyped, default_value: String) -> String
          def extract_or_default(value_object:, default_value:)
            value_object ? value_object.value : default_value
          end
        end
      end
    end
  end
end
