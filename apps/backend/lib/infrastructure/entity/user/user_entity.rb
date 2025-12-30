# frozen_string_literal: true

# rbs_inline: enabled

module Infrastructure
  module Entity
    module User
      class UserEntity < Infrastructure::Entity::BaseEntity
        # @rbs!
        #   attr_reader id: String
        #   attr_reader first_name: String
        #   attr_reader last_name: String
        #   attr_reader email: String
        attribute :id, ROM::Types::String
        attribute :first_name, ROM::Types::String
        attribute :last_name, ROM::Types::String
        attribute :email, ROM::Types::String

        # @rbs () -> ::Domain::Entity::User::UserEntity
        def to_domain
          ::Domain::Entity::User::UserEntity.build_with_id(id: id, first_name: first_name, last_name: last_name,
                                                           email: email)
        end

        def to_domain_with_auth_user; end

        # @rbs (untyped struct) -> ::Domain::Entity::User::UserEntity
        def self.struct_to_domain(struct)
          user_entity = new(
            id: struct.id,
            first_name: struct.first_name,
            last_name: struct.last_name,
            email: struct.email
          )
          user_entity.to_domain
        end

        # @rbs (untyped struct) -> {user_entity: Domain::Entity::User::UserEntity, auth_user_entity: Domain::Entity::Auth::AuthUserEntity}
        def self.struct_to_domain_with_auth_user(struct)
          user_entity = struct_to_domain(struct)
          auth_user_entity = ::Infrastructure::Entity::Auth::AuthUserEntity.struct_to_domain(struct.auth_user)
          {
            user_entity: user_entity,
            auth_user_entity: auth_user_entity
          }
        end

        # @rbs (::Domain::Entity::User::UserEntity entity) -> UserEntity
        def self.build_from_domain_entity(entity)
          new(
            id: ::UtilMethod.nil_or_empty?(entity.id&.value) ? SecureRandom.uuid : entity.id.value,
            first_name: entity.user_name.first_name,
            last_name: entity.user_name.last_name,
            email: entity.email.value
          )
        end

        # rubocop:disable Layout/LineLength
        # @rbs ({user_name: Domain::ValueObject::User::UserName, email: Domain::ValueObject::User::UserEmail, auth_user: {email: Domain::ValueObject::User::UserEmail, password_digest: Domain::ValueObject::AuthUser::PasswordDigest}}) -> {first_name: String, last_name: String, email: String, auth_user: {email: String, password_digest: String}}
        # rubocop:enable Layout/LineLength
        def self.build_with_auth_user(attrs)
          {
            first_name: attrs[:user_name].first_name,
            last_name: attrs[:user_name].last_name,
            email: attrs[:email].value,
            auth_user: {
              email: attrs[:auth_user][:email].value,
              password_digest: attrs[:auth_user][:password_digest].value
            }
          }
        end
      end
    end
  end
end
