# frozen_string_literal: true

module Infrastructure
  module Entity
    module User
      class UserEntity < Infrastructure::Entity::BaseEntity
        attribute :id, ROM::Types::String
        attribute :first_name, ROM::Types::String
        attribute :last_name, ROM::Types::String
        attribute :email, ROM::Types::String

        def to_domain(entity)
          ::Domain::Entity::User::UserEntity.build_from_entity(entity)
        end

        def self.struct_to_domain(struct)
          user_entity = new(
            id: struct.id,
            first_name: struct.first_name,
            last_name: struct.last_name,
            email: struct.email
          )
          user_entity.to_domain(user_entity)
        end

        def self.build(entity)
          new(
            id: ::UtilMethod.nil_or_empty(entity.id&.value) ? SecureRandom.uuid : entity.id.value,
            first_name: entity.user_name.first_name,
            last_name: entity.user_name.last_name,
            email: entity.email.value
          )
        end
      end
    end
  end
end
